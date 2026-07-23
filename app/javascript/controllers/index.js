// SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
//
// SPDX-License-Identifier: LicenseRef-LICENSE

// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
