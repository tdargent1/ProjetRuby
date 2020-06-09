module PostsHelper
    def post_status_label(boolean)
        boolean ? "Public" : "Brouillon"
    end
end