class TouchDependenciesWorker
  include Sidekiq::Worker

  def perform(model_class, id)
    model_class.constantize.find(id).touch_dependencies
  end
end
