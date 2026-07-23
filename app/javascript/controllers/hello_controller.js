// SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
//
// SPDX-License-Identifier: LicenseRef-LICENSE

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}
