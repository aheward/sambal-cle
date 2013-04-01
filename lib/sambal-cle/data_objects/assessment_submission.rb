class AssessmentSubmissionObject

  include Foundry
  include DataFactory
  include StringFactory
  include DateFactory
  include Navigation

  attr_accessor :assessment

  def initialize(browser, opts={})
    @browser = browser

    defaults = {

    }
    options = defaults.merge(opts)

    set_options(options)
    # Note that the assessment requirement is for the Assessment Object itself.
    requires :assessment
  end



end