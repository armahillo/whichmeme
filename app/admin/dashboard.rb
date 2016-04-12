ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }


  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
          panel "Flagged for Review" do
            table_for Meme.flagged do |m|
              column(:actions) { |m| link_to "Edit", edit_admin_meme_path(m) }
              column(:meme_type) { |m| m.meme_type.name }
              column(:title)
              column(:meme_caption) { |m| JSON.parse(m.meme_caption).join("<br/>").html_safe }
              column(:flagged_by) { |m| m.flagged_by.try(:name) rescue "unknown" }
            end
          end
      end
    end

    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
