class Admin::CategoriesController < ApplicationController
  def index
    @categories = Category.includes(:parent).all
  end

  def new
    @category   = Category.new
    @categories = Category.roots.map{|c| [c.name, c.id] }.unshift(['(Top Level)', nil])
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to([:edit, :admin, @category])
    else
      @categories = Category.roots.map{|c| [c.name, c.id] }.unshift(['(Top Level)', nil])
      render(action: :new)
    end
  end

  def edit
    @category   = Category.find(params[:id])
    @categories = Category.root.map{|c| [c.name, c.id] }.unshift(['(Top Level)', nil])
  end

  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(category_params)
      redirect_to([:edit, :admin, @category])
    else
      @categories = Category.all.map{|c| [c.name, c.id] }.unshift(['(Top Level)', nil])
      render(action: :edit)
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    redirect_to(:admin, :categories)
  end

private

  def category_params
    params.require(:category).permit(:parent_id, :name)
  end
end
