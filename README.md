# Whooshly Share Buttons for Google Tag Manager

A web tag template that adds Whooshly share buttons to a page. It loads `https://whooshly.co/share.js?via=gtm` and can show a floating rail, place buttons after a CSS selector, or configure manually placed `<whooshly-share>` elements. You can choose networks and opt in to a small Whooshly icon.

## Install and configure

1. In Google Tag Manager, open **Templates → Tag Templates → Search Gallery**, find **Whooshly Share Buttons**, and add it. Until the Gallery listing is available, import [`template.tpl`](template.tpl) with **Templates → Tag Templates → New → Import**.
2. Create a tag using **Whooshly Share Buttons**. Choose its placement and networks, then attach an **All Pages** trigger.
3. Use **Preview** on an HTTPS test site before publishing your GTM container.

See the [full setup guide](https://whooshly.co/docs/share-kit/platforms#google-tag-manager).

## Permissions and privacy

This template requests only `inject_script` for `https://whooshly.co/share.js*`. The share buttons do not set cookies. When a visitor presses or hovers over a share button, the page URL and chosen network are sent to Whooshly to create a short link; Whooshly also receives the request IP for abuse controls. See the [privacy policy](https://whooshly.co/privacy).

Report problems in [Issues](https://github.com/ankurmans/whooshly-share-gtm-template/issues). The source and local tests also live in the [Whooshly repository](https://github.com/ankurmans/whooshly/tree/main/integrations/gtm).

Licensed under Apache 2.0.
