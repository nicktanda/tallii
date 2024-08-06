import { application } from "controllers/application"

import CheckoutController from "controllers/checkout_controller";
application.register("checkout", CheckoutController);