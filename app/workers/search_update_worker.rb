class SearchUpdateWorker
  include Sidekiq::Worker

  def perform
    WaterItem.reindex
    SewageItem.reindex
    ProjectItem.reindex
    RepairPart.reindex
    Emergency.reindex
    Stuff.reindex
  end

end
