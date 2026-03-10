import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import concatClass from "discourse/helpers/concat-class";
import routeAction from "discourse/helpers/route-action";
import replaceEmoji from "discourse/helpers/replace-emoji";
import DButton from "discourse/components/d-button";
import DModal from "discourse/components/d-modal";
import LoginButtons from "discourse/components/login-buttons";
import DiscourseURL from "discourse/lib/url";
import I18n from "discourse-i18n";

export default class GuestGateModal extends Component {  
  @service siteSettings;
  @service login;

  get guestGateModalTitle() {
    return I18n.t(themePrefix("guest_gate.title"));
  }

  get customBigText() {
    return htmlSafe(I18n.t(themePrefix("custom_gate.big_text")));
  }

  get customLittleText() {
    return htmlSafe(I18n.t(themePrefix("custom_gate.little_text")));
  }

  get signupCtaIntro() {
    return replaceEmoji(I18n.t("signup_cta.intro"));
  }

  get signupCtaValueProp() {
    return replaceEmoji(I18n.t("signup_cta.value_prop"));
  }

  get guestGateLogin() {
    return I18n.t(themePrefix("guest_gate.log_in"));
  }

  get guestGateSignup() {
    return I18n.t(themePrefix("guest_gate.sign_up"));
  }

  get guestGateSsoLogin() {
    return I18n.t(themePrefix("guest_gate.sso_log_in"));
  }

  get guestGateSsoSignup() {
    return I18n.t(themePrefix("guest_gate.sso_sign_up"));
  }

  get guestGateOr() {
    return I18n.t(themePrefix("guest_gate.or"));
  }

  willDestroy() {
    super.willDestroy(...arguments);
    document.body.classList.remove("has-guest-gate");
  }

  @action
  externalLogin(provider) {
    // we will automatically redirect to the external auth service
    this.login.externalLogin(provider, { signup: true });
  }

  @action
  redirectToSso() {
    DiscourseURL.redirectTo("/session/sso?return_path=/t/sparq-1-0-beta-release/17");
  }

  <template>
    <DModal
      @closeModal={{@closeModal}}
      @title={{this.guestGateModalTitle}}
      class={{concatClass
        "gate"
        (if settings.custom_gate_enabled "custom-gate")
      }}
      @dismissable={{if settings.dismissable_false false true}}
    >
      <:body>
        {{#if settings.custom_gate_enabled}}
          <div class="custom-gate-content">
            <img src="{{settings.custom_gate_image}}"/>
            <h2>{{this.customBigText}}</h2>
            <p>{{this.customLittleText}}</p>
          </div>
        
        {{else}}
        
          <div>
            <p>{{this.signupCtaIntro}}</p>
            <p>{{this.signupCtaValueProp}}</p>
          </div>
        {{/if}}

        <LoginButtons
          @externalLogin={{this.externalLogin}}
          @context="create-account"
        />
      </:body>
      
      <:footer>
        {{#if this.siteSettings.enable_discourse_connect}}
          {{#if settings.use_gate_buttons}}
            <DButton
              @class={{settings.login_button_style}}
              @icon={{settings.login_icon}}
              @translatedLabel={{this.guestGateSsoLogin}}
              @action={{this.redirectToSso}}
            />
            {{#if settings.enable_discourse_connect_signup}}
              <DButton
                @class={{settings.signup_button_style}}
                @icon={{settings.signup_icon}}
                @translatedLabel={{this.guestGateSsoSignup}}
                @action={{this.redirectToSso}}
              />
            {{/if}}

          {{else}}

            <DButton
              @class="btn-transparent"
              @translatedLabel={{this.guestGateSsoLogin}}
              @action={{this.redirectToSso}}
            />

            {{#if settings.enable_discourse_connect_signup}}
              {{this.guestGateOr}}
              <DButton
                @class="btn-transparent"
                @translatedLabel={{this.guestGateSsoSignup}}
                @action={{this.redirectToSso}}
              />
            {{/if}}
          {{/if}}
                  
        {{else}}
                  
          {{#if settings.use_gate_buttons}}
            {{#if settings.custom_url_enabled}}
              <DButton
                @class={{settings.login_button_style}}
                @icon={{settings.login_icon}}
                @translatedLabel={{this.guestGateLogin}}
                @action={{this.redirectToSso}}
              />
              <DButton
                @class={{settings.signup_button_style}}
                @icon={{settings.signup_icon}}
                @translatedLabel={{this.guestGateSignup}}
                @action={{this.redirectToSso}}
              />

            {{else}}

              <DButton
                @class={{settings.login_button_style}}
                @icon={{settings.login_icon}}
                @translatedLabel={{this.guestGateLogin}}
                @action={{this.redirectToSso}}
              />
              <DButton
                @class={{settings.signup_button_style}}
                @icon={{settings.signup_icon}}
                @translatedLabel={{this.guestGateSignup}}
                @action={{this.redirectToSso}}
              />
            {{/if}}
                
          {{else}}
              
            {{#if settings.custom_url_enabled}}
              <DButton
                @class="btn-transparent"
                @translatedLabel={{this.guestGateLogin}}
                @action={{this.redirectToSso}}
              />

              {{this.guestGateOr}}
              
              <DButton
                @class="btn-transparent"
                @translatedLabel={{this.guestGateSignup}}
                @action={{this.redirectToSso}}
              />

            {{else}}

              <DButton
                @class="btn-transparent"
                @translatedLabel={{this.guestGateLogin}}
                @action={{this.redirectToSso}}
              />

              {{this.guestGateOr}}

              <DButton
                @class="btn-transparent"
                @translatedLabel={{this.guestGateSignup}}
                @action={{this.redirectToSso}}
              />
            {{/if}}
          {{/if}}
        {{/if}}
      </:footer>
    </DModal>
  </template>
}
