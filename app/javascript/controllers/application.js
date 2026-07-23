// SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
//
// SPDX-License-Identifier: LicenseRef-LICENSE

import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
