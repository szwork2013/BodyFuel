class Admin::ShirtsController < Admin::AdminController
  before_filter :get_colors, :get_sizes, only: [:edit, :new]
  before_filter :get_shirt, only: [:edit, :update, :destroy]

  def index
    @shirts = Shirt.includes(:shirt_colors).includes(:sizes).includes(:text_colors).not_deleted.most_recent
  end

  def update
    Shirt.transaction do
      if @shirt.update_attributes params[:shirt]
        @shirt.shirt_colors = filtered_shirt_colors
        @shirt.text_colors = filtered_text_colors
        @shirt.sizes = filtered_sizes
      else
        return render json: { errors: model_errors(@shirt) }, status: :unprocessable_entity
      end
    end
    respond_to do |format|
      format.json { render json: { path: admin_shirts_path }, status: :ok }
      format.html { redirect_to admin_shirts_path }
    end
  end

  def new
    @shirt = Shirt.new
  end

  def create
    @shirt = Shirt.new params[:shirt]
    Shirt.transaction do
      if @shirt.save
        @shirt.shirt_colors = filtered_shirt_colors
        @shirt.text_colors = filtered_text_colors
        @shirt.sizes = filtered_sizes
      else
        return render json: { errors: model_errors(@shirt) }, status: :unprocessable_entity
      end
    end
    respond_to do |format|
      format.json { render json: { path: admin_shirts_path }, status: :ok }
      format.html { redirect_to admin_shirts_path }
    end
  end

  def destroy
    @shirt.soft_delete
    render json: { path: admin_shirts_path }, status: :ok
  end

  private

  def filtered_shirt_colors
    ShirtColor.where(id: Array(JSON.parse(params[:shirt_colors])).map(&:with_indifferent_access).map{ |color| color[:id] }).all
  end

  def filtered_text_colors
    TextColor.where(id: Array(JSON.parse(params[:text_colors])).map(&:with_indifferent_access).map{ |color| color[:id] }).all
  end

  def filtered_sizes
    Size.where(id: Array(JSON.parse(params[:sizes])).map(&:with_indifferent_access).map{ |size| size[:id] }).all
  end

  def get_shirt
    @shirt = Shirt.find params[:id]
  end

  def get_colors
    @shirt_colors = ShirtColor.all
    @text_colors = TextColor.all
  end

  def get_sizes
    @sizes = Size.all
  end
end