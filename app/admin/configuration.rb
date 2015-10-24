ActiveAdmin.register Configuration do
  actions only: [:index, :update]

  before_filter do
    @skip_sidebar = true
  end

  config.comments = false
  config.clear_action_items!

  controller do
    def index
      params[:action] = 'Organisation Details' # for the active admin title
      render 'admin/configuration/index', layout: 'active_admin'
    end

    def update
      params.require(:update_configuration).permit(Configuration.settings).each do |setting, value|
        Configuration.send("#{setting}=", value)
      end
      redirect_to admin_configurations_path, notice: 'Settings Saved'
    end
  end

  # Ensure all the defaults are created when the class file is read
  Configuration.ensure_created
end