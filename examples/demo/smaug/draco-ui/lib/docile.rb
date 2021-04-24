# This is a stripped down fork of https://github.com/ms-ati/docile
#
# I have removed unneeded features, stripped the verbose inline docs,
# made a few adjustments for compatibility with DRGTK ruby, and
# concatenated the script into one file.

module Docile
  module Execution
    def exec_in_proxy_context(dsl, proxy_type, *args, &block)
      # Unlike mruby (without mruby-eval), DRGTK _does_ implement Kernel#eval,
      # but not #binding. Let's see if we can work around that limitation.
      #block_context = eval("self", block.binding)
      block_context = block

      return dsl.instance_exec(*args, &block) if dsl.equal?(block_context)

      proxy_context = proxy_type.new(dsl, block_context)
      begin
        block_context.instance_variables.each do |ivar|
          value_from_block = block_context.instance_variable_get(ivar)
          proxy_context.instance_variable_set(ivar, value_from_block)
        end

        proxy_context.instance_exec(*args, &block)
      ensure
        if block_context.respond_to?(:__docile_undo_fallback__)
          block_context.send(:__docile_undo_fallback__)
        end

        block_context.instance_variables.each do |ivar|
          next unless proxy_context.instance_variables.include?(ivar)
          value_from_dsl_proxy = proxy_context.instance_variable_get(ivar)
          block_context.instance_variable_set(ivar, value_from_dsl_proxy)
        end
      end
    end

    module_function :exec_in_proxy_context
  end

  class FallbackContextProxy
    # The set of methods which will **not** be proxied, but instead answered
    # by this object directly.
    NON_PROXIED_METHODS = Set[:__send__, :object_id, :__id__, :==, :equal?,
                              :"!", :"!=", :instance_exec, :instance_variables,
                              :instance_variable_get, :instance_variable_set,
                              :remove_instance_variable, :xrepl, :s_or_default,
                              :f_or_default, :eval, :try_dsl, :numeric_or_default,
                              :define_singleton_method, :Hash, :singleton_methods,
                              :caller, :to_s, :method_missing, :raise, :rand, :__custom_object_methods__,
                              :nil?, :fail, :autocomplete_methods, :__printstr__, :sleep, :enum_for, :i_or_default, :initialize, :require,
                              :Integer, :better_instance_information, :log_bright_magenta, :raise_error_with_kind_of_okay_message,
                              :instance_variable_defined?, :log_bright_blue, :docs, :log_bright_yellow, :raise_method_missing_better_error,
                              :log_bright_green, :better_class_hierarchy_information, :tap, :tick, :__looks_like_docs__?, :_inspect, :log_error,
                              :__normalized_docs_method__, :private_methods, :Array, :log_once_info, :sprintf, :gets, :log_bright_cyan, :help,
                              :getc, :__try_invoke_docs_method__, :log_bright_white, :protected_methods, :clone, :method_missing_core,
                              :instance_eval, :public_methods, :__caller_without_noise__, :singleton_class, :log_white, :freeze, :puts,
                              :__gtk_ruby_string_contains_source_file_path__?, :respond_to?, :log_cyan, :dup, :to_enum, :log_bright_red,
                              :__case_eqq, :__pretty_print_exception__, :local_variables, :String, :__to_int, :log_bright_black,
                              :__gtk_ruby_source_files__, :__supports_ivars__?, :usleep, :__help_contract_implementation, :log_green, :comment,
                              :__to_str, :is_a?, :lambda, :fast_rand, :instance_of?, :primitive_marker, :log_yellow, :associate]

    # The set of methods which will **not** fallback from the block's context
    # to the dsl object.
    NON_FALLBACK_METHODS = Set[:class, :self, :respond_to?, :instance_of?]

    # The set of instance variables which are local to this object and hidden.
    # All other instance variables will be copied in and out of this object
    # from the scope in which this proxy was created.
    NON_PROXIED_INSTANCE_VARIABLES = Set[:@__receiver__, :@__fallback__]

    # Undefine all instance methods except those in {NON_PROXIED_METHODS}
    instance_methods.each do |method|
      begin
        undef_method(method) unless NON_PROXIED_METHODS.include?(method.to_sym)
      rescue NameError => e
        # Should be safe to ignore
        # puts e
      end
    end

    def initialize(receiver, fallback)
      @__receiver__ = receiver
      @__fallback__ = fallback

      # Enables calling DSL methods from helper methods in the block's context
      unless fallback.respond_to?(:method_missing)
        singleton_class = (class << fallback; self; end)

        # instrument {#method_missing} on the block's context to fallback to
        # the DSL object. This allows helper methods in the block's context to
        # contain calls to methods on the DSL object.
        singleton_class.
          send(:define_method, :method_missing) do |method, *args, &block|
            m = method.to_sym
            if !NON_FALLBACK_METHODS.include?(m) && !fallback.respond_to?(m) && receiver.respond_to?(m)
              receiver.__send__(method.to_sym, *args, &block)
            else
              super(method, *args, &block)
            end
          end

        singleton_class.send(:ruby2_keywords, :method_missing) if singleton_class.respond_to?(:ruby2_keywords, true)

        # instrument a helper method to remove the above instrumentation
        singleton_class.
          send(:define_method, :__docile_undo_fallback__) do
            singleton_class.send(:remove_method, :method_missing)
            singleton_class.send(:remove_method, :__docile_undo_fallback__)
          end
      end
    end

    def instance_variables
      super.select { |v| !NON_PROXIED_INSTANCE_VARIABLES.include?(v.to_sym) }
    end

    def method_missing(method, *args, &block)
      if @__receiver__.respond_to?(method.to_sym)
        @__receiver__.__send__(method.to_sym, *args, &block)
      else
        begin
          @__fallback__.__send__(method.to_sym, *args, &block)
        rescue NoMethodError => e
          e.extend(BacktraceFilter)
          raise e
        end
      end
    end
  end

  class ChainingFallbackContextProxy < FallbackContextProxy
    # Proxy methods as in {FallbackContextProxy#method_missing}, replacing
    # `receiver` with the returned value.
    def method_missing(method, *args, &block)
      @__receiver__ = super(method, *args, &block)
    end
  end

  extend Execution

  def dsl_eval(dsl, *args, &block)
    exec_in_proxy_context(dsl, FallbackContextProxy, *args, &block)
    dsl
  end

  module_function :dsl_eval

  def dsl_eval_with_block_return(dsl, *args, &block)
    exec_in_proxy_context(dsl, FallbackContextProxy, *args, &block)
  end

  module_function :dsl_eval_with_block_return

  def dsl_eval_immutable(dsl, *args, &block)
    exec_in_proxy_context(dsl, ChainingFallbackContextProxy, *args, &block)
  end

  module_function :dsl_eval_immutable
end

# The MIT License (MIT)
# 
# Copyright (c) 2012-2021 Marc Siegel
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
