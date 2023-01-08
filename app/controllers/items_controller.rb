class ItemsController < ApplicationController

  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      if user
        items = user.items
      else
        return render_not_found_response
      end
    else
      items = Item.all 
    end
    render json: items, include: :user
  end

  def show
    user = User.find_by(id: params[:user_id])
    if user
      item = user.items.find_by(id: params[:id])
      if item
        render json: item
      else
        return render_not_found_response
      end
    else
      return render_not_found_response
    end
  end

  def create
    user = User.find_by(id: params[:user_id])
    if user
      item = user.items.create(item_params)
      render json: item, status: :created
    else 
      return render_not_found_response
    end
  end

  private

  def render_not_found_response
    render json: {error: "item not found"}, status: :not_found 
  end

  def item_params
    params.permit(:name, :description, :price)
  end

end
