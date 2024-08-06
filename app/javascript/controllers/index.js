import { application } from "controllers/application"

// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
// eagerLoadControllersFrom("controllers", application)
import CheckoutController from "controllers/checkout_controller";
application.register("checkout", CheckoutController);    