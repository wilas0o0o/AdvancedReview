class GroupsController < ApplicationController
  before_action :ensure_correct_method, only: [:edit,:update]
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to groups_path,notice: "You have created new Group."
    else
      render :new
    end
  end

  def index
    @groups = Group.all
    @book = Book.new
  end

  def show
    @group = Group.find(params[:id])
    @group_members = @group.users.all
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "You have updated Group."
    else
      @group = Group.find(params[:id])
      render :edit
    end
  end

  def join
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to group_path(@group),notice: "You have joined this group."
  end

  def leave
    @group = Group.find(params[:group_id])
    @group.users.delete(current_user)
    redirect_to groups_path, notice: "You have left group."
  end
  
  def new_mail
    @group = Group.find(params[:group_id])
  end
  
  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @title = params[:title]
    @content = params[:content]
    GroupMailer.send_mail(group_users,@title,@content).deliver
  end

  private
  def group_params
    params.require(:group).permit(:name,:introduction,:image)
  end

  def ensure_correct_method
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
