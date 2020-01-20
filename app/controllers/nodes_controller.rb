class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]
  before_action :set_account, only: [:index]
  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = @account.nodes.hash_tree
    # puts @nodes.to_json
    # render :json => @nodes
  end

  def episode_form
    if params[:parent_id]
      @parent_node = Node.find(params[:parent_id])
      @parent_node_type = @parent_node.node_type
      if @parent_node_type == 'episodes'
        @node_type = 'episode'
      end
    end
    @node = Node.new(parent_id: params[:parent_id], node_type: @node_type)
    @assignments = @node.assignments.build
  end

  def create_episode_form
    @node = Node.new(node_params)

    respond_to do |format|
      if @node.save
          @pre_production = Node.create(name: 'Pre Production', node_type: "category", account_id: @node.account.id, state: "a", parent: @node)
          @production = Node.create(name: 'Production', node_type: "category", account_id: @node.account.id, state: "a", parent: @node)
          @post_production = Node.create(name: 'Post Production', node_type: "category", account_id: @node.account.id, state: "a", parent: @node)
          @pre_production.save!
          @production.save!
          @post_production.save!
          format.html { redirect_to node_path(@node), notice: 'Node was successfully created.' }
          format.json { render :show, status: :created, location: @node }
      else
        format.html { render :new }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  def task_form
    if params[:parent_id]
      @parent_node = Node.find(params[:parent_id])
      @parent_node_type = @parent_node.node_type
      if @parent_node_type == 'category'
        @node_type = 'task'
      end
    end
    @node = Node.new(parent_id: params[:parent_id], node_type: @node_type)
    @assignments = @node.assignments.build
    @shot_files = @node.shot_files.build
  end

  def create_task_form
    @node = Node.new(node_params)

    respond_to do |format|
      if @node.save
          format.html { redirect_to node_path(@node.parent.parent.id), notice: 'Node was successfully created.' }
          format.json { render :show, status: :created, location: @node }
      else
        format.html { render :new }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_info
    @user = User.find(params[:user_id])

    render "/nodes/_user_info", layout: false
  end
  # GET /nodes/1
  # GET /nodes/1.json
  def show
    @node_tree = @node.hash_tree
  end

  # GET /nodes/new
  # def new
  #   @node = Node.new
  # end

  def new
    if params[:parent_id]
      @parent_node = Node.find(params[:parent_id])
      @parent_node_type = @parent_node.node_type
      if @parent_node_type == 'series'
        @node_type = 'episodes'
      elsif @parent_node_type == 'episodes'
        @node_type = 'episode'
      elsif @parent_node_type == 'episode'
        @node_type = 'category'
      elsif @parent_node_type == 'category'
        @node_type = 'task'
      else
        @node_type = ''
      end
    end
    @node = Node.new(parent_id: params[:parent_id], node_type: @node_type)
  end

  # GET /nodes/1/edit
  def edit
  end

  # POST /nodes
  # POST /nodes.json
  def create
    if params[:node][:parent_id].to_i > 0
      parent = Node.find_by_id(params[:node].delete(:parent_id))
      @node = parent.children.build(node_params)
    else
      @node = Node.new(node_params)
    end

    respond_to do |format|
      if @node.save
        @episodes = Node.create(name: "episodes", node_type: "episodes", account_id: @node.account.id, state: "a", parent: @node)
        if @node.node_type == 'series'
          format.html { redirect_to account_my_workspace_path(@node.account), notice: 'Node was successfully created.' }
          format.json { render :show, status: :created, location: @node }
        else
          format.html { redirect_to nodes_path, notice: 'Node was successfully created.' }
          format.json { render :show, status: :created, location: @node }
        end
      else
        format.html { render :new }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nodes/1
  # PATCH/PUT /nodes/1.json
  def update
    respond_to do |format|
      if @node.update(node_params)
        format.html { redirect_to @node, notice: 'Node was successfully updated.' }
        format.json { render :show, status: :ok, location: @node }
      else
        format.html { render :edit }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end
  

  def task_node_creation

  end
  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    @node.destroy
    respond_to do |format|
      format.html { redirect_to nodes_url, notice: 'Node was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node
      @node = Node.find(params[:id])
    end

    def set_account
      if current_user
        @account= current_user.accounts.last
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def node_params
      params.require(:node).permit!
    end
end
