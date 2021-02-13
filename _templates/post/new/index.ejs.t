---
to: content/posts/<%= new Date().toLocaleDateString('en-CA') + '-' + h.inflection.dasherize(title) %>/index.md
---

---
title: <%= h.inflection.titleize(title) %>
author: Eason Chang
description: ""
category: ""
tags:
  - Draft
socialImage: ""
date: <%= new Date().toISOString() %>
template: "post"
draft: true
---

## 標題
