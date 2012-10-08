# From
# http://justinfrench.com/notebook/silencing-deprecation-warnings-in-rspec

def with_deprecation_silenced(&block)
  previous_setting = ::ActiveSupport::Deprecation.silenced
  ::ActiveSupport::Deprecation.silenced = true
  yield
  ::ActiveSupport::Deprecation.silenced = previous_setting
end
	  

