#include <Rcpp.h>
#include <string>
#include <string.h>
#include <boost/regex.hpp>

using namespace boost;
using namespace Rcpp;
using namespace std;

//using boost::regex;
//using boost::regex_replace;
//using std::string;

boost::regex re_digits("[[:digit:]]");
boost::regex re_punct("[[:punct:]]");
boost::regex re_twitter("(^|\\s)(#|@)\\S+");
boost::regex re_url("(?i)\\b((?:[a-z][\\w-]+:(?:/{1,3}|[a-z0-9%])|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:\\'\".,<>?]))");

//boost::regex re_digits("");
//boost::regex re_punct("");
//boost::regex re_twitter("");
//boost::regex re_url("");

const std::string space0 = std::string("");
const std::string space1 = std::string(" ");
const std::string space2 = std::string("  ");

// [[Rcpp::export]]
Rcpp::CharacterVector tokenizecpp(SEXP x, SEXP sep, 
                       SEXP minLength,
                       SEXP toLower, 
                       SEXP removeDigits,
                       SEXP removePunct,
                       SEXP removeTwitter,
                       SEXP removeURL,
                       SEXP removeAdditional){
  
  std::string str = Rcpp::as <string> (x); 
  std::string delim = Rcpp::as <string> (sep);
  const char *delim_char = delim.c_str();
  int len_min = Rcpp::as <int> (minLength);
  bool to_lower = Rcpp::as <bool> (toLower);
  bool rm_digts = Rcpp::as <bool> (removeDigits);
  bool rm_punct = Rcpp::as <bool> (removePunct);
  bool rm_twitter = Rcpp::as <bool> (removeTwitter);
  bool rm_url = Rcpp::as <bool> (removeURL);
  
  
  std::string rm_addit = Rcpp::as <string> (removeAdditional);
  
  // Regexp cleaning
  if(rm_digts) str = boost::regex_replace(str, re_digits, space0);
  if(rm_punct) str = boost::regex_replace(str, re_punct, space0);
  Rcout << "String: '" << str << "'\n";
  if(rm_twitter) str = boost::regex_replace(str, re_twitter, space1);
  if(rm_url) str = boost::regex_replace(str, re_url, space0);
  if(rm_addit.length() > 0){
    try{
      boost::regex re_addit(rm_addit, boost::regex::basic);
      str = boost::regex_replace(str, re_addit, space0);
    }catch(boost::regex_error& e){
      Rcout << "Invalid regular expression given: " <<  rm_addit << "\n";
    }
  }
  
  int len_str = str.length();
  int i_pos = 0;
  int i_len = 0;
  bool flag_token = false;
  std::string token;
  std::vector <std::string> tokens;
  
  //Rcout << "String: '" << str << "'\n";
  for(int i=0; i <= len_str; i++){
    if(to_lower) str[i] = tolower(str[i]);
    //Rcout << i << ": " << i_pos << " " << i_len << " " << flag_token << " " << str[i] << "\n";
    i_len = i - i_pos;
    //if(!std::isalpha(str[i], loc) || str[i] == delim_char[0] || i == len_str){
    if(str[i] == delim_char[0] || i == len_str){
      token = str.substr(i_pos, i_len);
      
      if(flag_token){
        if(i_len >= len_min){
          tokens.push_back(token);
          //Rcout << i << ": " << i_pos << "-" << i - 1 << " " << token << "\n";
        }
        flag_token = false;
      }
    }else{
      if(!flag_token){
        i_pos = i;
        flag_token = true;
      }
    }
  }    
  return wrap(tokens);

}

