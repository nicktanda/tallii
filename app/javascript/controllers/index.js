import { application } from "controllers/application"

import CheckoutController from "./checkout_controller"
application.register("checkout", CheckoutController)