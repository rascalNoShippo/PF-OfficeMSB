class OrganizationsController < ApplicationController
  before_action :init
	before_action :uniqueness, only: [:create, :update], if: -> {request.format == :js}

  def init
    raise Forbidden unless current_user.is_admin
    @title = "組織"
    @Class = Organization
  end

	def uniqueness
		# 組織名が重複しないよう制限
		item = @Class.find_by(name: (params[@Class.to_s.downcase][:name]))
		#変更の場合は、現在の組織名から変更がなければそのまま通す
		no_change = item == @Class.find(params[:id]) if params[:id]
		@exist = item && !no_change
		render "organizations/uniqueness"
	end

  def index
    @orgs = @Class.all
    @positions = Position.all
    @q = params[:query]
  end

  def new
    @item = @Class.new
  end

  def create
    item = @Class.new(item_params)
    if item.save
      flash[:notice] = "#{@title} “#{item.name}” を作成しました。"
      redirect_to organizations_path
    end
  end

  def show
    @item = @Class.find(params[:id])
  end

  def update
    item = @Class.find(params[:id])
    name_old = item.name
    item.update(item_params)
    flash[:notice] = "#{@title} “#{name_old}” を “#{item.name}” に変更しました。"
    redirect_to organizations_path
  end

  def destroy
    item = @Class.find(params[:id])
    name = item.name
    item.destroy
    flash[:notice] = "#{@title} “#{name}” を削除しました。"
    redirect_to organizations_path
  end

  private

  def item_params
		params.require(@Class.to_s.downcase).permit(:name)
  end

end
