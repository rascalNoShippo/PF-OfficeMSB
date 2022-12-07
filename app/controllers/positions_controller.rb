class PositionsController < OrganizationsController
  before_action :init
	before_action :uniqueness, only: [:create, :update], if: -> {request.format == :js}

  def init
    raise Forbidden unless current_user.is_admin
    @title = "役職"
    @Class = Position
  end

	def uniqueness
		super
	end

  def new
    super
  end

  def create
    super
  end

  def show
    super
  end

  def update
    super
  end

  def destroy
    super
  end

end
