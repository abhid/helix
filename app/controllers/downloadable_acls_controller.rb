class DownloadableAclsController < ApplicationController
  def index
    @pagy, @downloadable_acls = pagy(DownloadableAcl.order(:name).all)
  end
end
