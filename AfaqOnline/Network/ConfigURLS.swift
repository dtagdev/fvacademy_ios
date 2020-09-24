//
//  ConfigURLS.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/18/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation

var BASE_URL = "https://dev.fv.academy"
var MOBILE_API = "/api/mobile"
var DASHBOARD_API = "/api/dashboard"
var AUTH = "/api/auth"
var SEARCH = "/api/search"
var CHAT = "/api/chat"
var AUTH_MOBILE = "/api/auth/mobile"
struct ConfigURLS {
    //MARK:- POST Register
    static var postRegister = BASE_URL + AUTH + "/register"
    //MARK:- POST Login
    static var postLogin = BASE_URL + AUTH + "/login"
    //MARK:- GET Jobs
    static var getJobs = BASE_URL + MOBILE_API + "/job_list"
    //MARK:- GET All Categories
    static var getAllCategories = BASE_URL + MOBILE_API + "/all_categories"
    //MARK:- GET All Instructors
    static var getAllInstructors = BASE_URL + MOBILE_API + "/all_instructors"
    //MARK:- GET Courses of a Category
    static var getCoursesOfCategory = BASE_URL + MOBILE_API + "/courses/"
    //MARK:- GET Course Details
    static var getCourseDetails = BASE_URL + MOBILE_API + "/course_details/"
    //MARK:- GET Course Comments
    static var getCourseComments = BASE_URL + MOBILE_API + "/get_comment_of_course"
    //MARK:- GET User Courses
    static var getUserCourses = BASE_URL + AUTH_MOBILE + "/get_courses_of_user"
    //MARK:- POST ADD Course Comment
    static var postCourseComment = BASE_URL + AUTH_MOBILE + "/add_comment"
    //MARK:- GET Home Data
    static var getHomeData = BASE_URL + MOBILE_API + "/home_data"
    //MARK:- POST Add Rate
    static var postAddRate = BASE_URL + MOBILE_API + "/add_rate"
    //MARK:- GET All Courses
    static var getAllCourses = BASE_URL + MOBILE_API + "/all_courses"
    
    //MARK:- GET All Events
    static var getAllEvent = BASE_URL + MOBILE_API + "/allEvents"
    
    //MARK:- GET Related Courses
    static var getRelatedCourses = BASE_URL + MOBILE_API + "/related_courses"
    
    //MARK:- GET User WishList
    static var getUserWishList = BASE_URL + AUTH_MOBILE + "/user_wish_list"
    
    //MARK:- POST Add To Wishlist
    static var postAddToWishlist = BASE_URL + AUTH_MOBILE + "/add_wish_list"
    
    //MARK:- POST DELETE From Wishlist
    static var postDeletFromWishlist = BASE_URL + AUTH_MOBILE + "/delete_wishlist/"
    //MARK:- GET Instructor Details
    static var getInstructorDetails = BASE_URL + MOBILE_API + "/instructor_details/"
    
    //MARK:- GET Profile
    static var getProfile = BASE_URL + AUTH + "/me"
    
    //MARK:- POST Search by word
    static var postSearchByWord = BASE_URL + SEARCH + "/search_by_word"
    
    //MARK:- POST Forget Password
    static var postForgetPassword = BASE_URL + AUTH + "/forgetpass"
    
    //MARK:- Check User Code
    static var getCheckUserCode = BASE_URL + AUTH + "/checkUserCode"
    
    //MARK:- POST Update Password
    static var postUpdatePassword = BASE_URL + AUTH + "/update_password"
    
    //MARK:- POST Add To Cart
    static var postAddToCart = BASE_URL + AUTH_MOBILE + "/add_to_cart"
    
    //MARK:- POST Add Comment
    static var postAddComment = BASE_URL + AUTH_MOBILE + "/add_comment"
    //MARK:- Chat APIs
    //MARK:- Send Message
    static var sendMessage = BASE_URL + CHAT + "/send_message"
    //MARK:- GET Room Chat
    static var getRoomChat = BASE_URL + CHAT + "/specific_room"
}
