# Hanldes login from a json request
# @author Charles Palmer
class API::SessionsController < API::ApplicationController
  skip_before_action :login_required

  # POST /session.json
  def create
    user_detail =
        UserDetail.authenticate(params[:login], params[:password])

    respond_to do |format|
      format.json do
        if user_detail
          render json: true
        else
          render json: false
        end
      end
    end
  end

end
