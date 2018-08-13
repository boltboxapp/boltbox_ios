//
//  HttpMacro.swift
//  VRS
//
//  Created by Guru Prasad chelliah on 6/8/17.
//  Copyright © 2017 project. All rights reserved.
//

import Foundation

let WEB_SERVICE_URL = "http://dreamguys.co.in/thegigs/api/"
let WEB_BASE_URL = "http://dreamguys.co.in/thegigs/"

// Request
let kCASE = "Case"
let kLAST_UPDATED_TIME = "last_updated_time"

// Case Name
let CASE_LOGIN = "user/login"
let CASE_DEVICE_ID = "gigs/save_device_id"
let CASE_LOGOUT = "user/logout"
let CASE_SIGNUP = "user/signup"
let CASE_FORGOT_PASSWORD = "user/forgot_password"
let CASE_CHANGE_PASSWORD = "user/change_password"
let CASE_REGISTER = "user/registration"
let CASE_UPDATE_PROFILE = "user/profile"
let CASE_VIEW_USER_PROFILE = "user/profile_details"
let CASE_VIEW_EDIT_GIG_DETAIL = "/gigs/edit_gigs/"
let CASE_COUNTRY = "user/country"
let CASE_STATE = "user/state"
let CASE_HOME_GIGS = "/gigs/"
let CASE_HOME_VIEWALL_GIGS = "gigs/categories"
let CASE_GIGS_DETAILS = "gigs/gigs_details"
let CASE_HOME_FAVOURTIES_GIGS = "gigs/favourites_gigs"
let CASE_HOME_ADD_FAVOURTIES_GIGS = "gigs/add_favourites"
let CASE_HOME_REMOVE_FAVOURTIES_GIGS = "gigs/remove_favourites"
let CASE_HOME_LAST_VISITED_GIGS = "gigs/last_visited_gigs"
let CASE_HOME_MY_GIGS = "gigs/my_gigs/"
let CASE_HOME_SEARCH = "gigs/search_gig"
let CASE_CREATE_GIGS = "gigs/create_gigs"
let CASE_UPDATE_GIGS = "gigs/update_gigs"
let CASE_PAYPAL = "user/paypal_setting"
let CASE_SETTINGS = "gigs/footer_menu"
let CASE_LANGUAGE = "user/speaking_language/ios"
let CASE_PROFESSION = "user/profession/iOS"
let CASE_VIEWALL_USERREVIEWS = "gigs/seller_reviews"
let CASE_VIEWALL_BUYER_REVIEWS = "gigs/seller_buyer_review"
let CASE_CONTACT_MESSAGE = "gigs/buyer_chat"
let CASE_ADD_FAVOURITES = "/gigs/add_favourites"
let CASE_REMOVE_FAVOURITES = "/gigs/remove_favourites"
let CASE_TERMS_AND_CONDITION = "/gigs/terms"
let CASE_BUY_SERVICE = "gigs/buy_now"
let CASE_PAYPAL_SUCCESS_SERVICE = "gigs/paypal_success"
let CASE_STRIPE_CHARGE = "charge"
let CASE_MY_ACTIVITY = "gigs/my_gig_activity"
let CASE_PAYPAL_PAYMENT_CANCEL = "gigs/buyer_cancel"
let CASE_STRIPE_PAYMENT_CANCEL = "gigs/stripe_account_details"
let CASE_STRIPE_PAYMENT_SETTINGS = "gigs/stripe_account_details"
let CASE_AMOUNT_WITHDRAW = "gigs/withdram_payment_request"
let CASE_ORDER_STATUS = "gigs/sale_order_status"
let CASE_COMPLETE_REQUEST = "gigs/change_gigs_status"
let CASE_COMPLETE_REQUEST_REJECT = "gigs/rejected_orders"
let CASE_CHAT_LIST = "gigs/messages"
let CASE_CHAT_DETAIL = "gigs/chat_details"
let CASE_CHAT_USER = "gigs/user_chat"
let CASE_USER_PRICE_TYPE = "gigs/price_details"
let CASE_SEE_FEEDBACK = "gigs/seefeedback"
let CASE_LEAVE_FEEDBACK = "gigs/leave_feedback"
let CASE_STRIPE_PAYMENT = "gigs/gig_stripe_payment"

let CASE_LAST_VISITED_GIGS = "gigs/last_visit" //Background run

//let CASE_PROFILE = "dashboard.php"
//let CASE_EDIT_PROFILE = "profile.php"

// Response
let kRESPONSE = "Response"
let kRESPONSE_MESSAGE = "response_message"
let kRESPONSE_CODE = "response_code"

let kRESPONSE_SUCCESS = "success"
let kRESPONSE_FAILURE = "failure"

let kDEVICE_TYPE = "device_type"
let kDEVICE_TYPE_IOS = "iOS"
let kDEVICE_CATEGORY_ID = "category_Id"
let kDEVICE_CATEGORY_iD = "category_id"
let kDEVICE_TITLE = "title"
let kDEVICE_STATE = "state"
let kDEVICE_COUNTRY = "country"
let kUSER_ID = "user_id"

let kDEVICE_VIEWALL = "services"
let kDEVICE_VIEWALL_SERVICES = "ALL"

// Alert Title
let ALERT_NO_RECORDS_FOUND = "No records found. "
let ALERT_NO_INTERNET_DESC = "Oops!! Itseems like you are not connected to internet"
let ALERT_UNABLE_TO_REACH_DESC = "Unable to reach server at the moment"
let ALERT_REQUIRED_FIELDS = "Please provide the required information"
let ALERT_EMPTY_FIELD = "Cannot be blank"
let ALERT_PAYPAL_EMPTY_FIELD = "Paypal Email field cannot be blank"
let ALERT_PASSWORD_FIELD = "Password field cannot be blank"
let ALERT_PHONENO = "Phone number must be 10 digits"
let ALERT_EMAIL_ID = "Email address is valid"
let ALERT_EMAIL_ID_NOTVALID = "Email address is not valid"
let ALERT_PASSWORD = "Password must be atleast 8 characters long. To make it stronger,use upper and lower case letters,numbers and symbols"
let ALERT_PASSWORD_MATCH = "Passwords do not match"
let ALERT_NOT_VALID = "Username or Password is not valid"
let ALERT_USER_NAME = "User name cannot be blank"
let ALERT_REASON_FIELD = "Reason field cannot be blank"
let ALERT_ACCOUNT_HOLDER_NAME_FIELD = "Account Holder Name field cannot be blank"
let ALERT_ACCOUNT_NO_FIELD = "Account Number field cannot be blank"
let ALERT_BANK_NAME_FIELD = "Bank Name field cannot be blank"
let ALERT_BANK_ADDRESS_FIELD = "Bank Address field cannot be blank"
let ALERT_SORT_CODE_FIELD = "Sort Code field cannot be blank"
let ALERT_ROUTING_NUMBER_FIELD = "Routing Number field cannot be blank"
let ALERT_IFSC_CODE_FIELD = "IFSC Code field cannot be blank"
let ALERT_IBAN_FIELD = "IBAN field cannot be blank"
let ALERT_COMMENTS = "Please write your comments"
let ALERT_ANYONE_FIELDS = "Please provide anyone code information"

// Response Code
let RESPONSE_CODE_200 = 200
let RESPONSE_CODE_498 = 498
let RESPONSE_CODE_404 = 404

// Alert type
let ALERT_TYPE_NO_INTERNET = "No Internet"
let ALERT_TYPE_NO_DATA = "No records found"
let ALERT_TYPE_SERVER_ERROR = "Server error"

// Parameters
let K_USER_ID = "user_id"
let K_SUB_CATEGORY_ID = "sub_category_id"
let K_GIG_ID = "gig_id"
let K_USER_id = "userid"
let K_USER_NAME = "email"
let K_PASSWORD = "password"
let K_DEVICE_ID = "device_id"
let K_DEVICE_TYPE = "device_type"
let K_FIRST_NAME = "first_name"
let K_LAST_NAME = "last_name"
let K_PHONE = "phone"
let K_ADDRESS = "address"
let K_CITY = "city"
let K_STATE = "state"
let K_ORDER_ID = "order_id"

let K_SESSION_ID = "session_id"
let K_USER_PASSWORD = "new_password"
let K_CONFIRM_PASSWORD = "conform_password"
let K_ITEM_NUMBER = "item_number"
let K_PAYPAL_ID = "paypal_uid"
		
