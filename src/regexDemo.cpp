#include <Rcpp.h>
#include <string.h>
#include <boost/regex.hpp>

using namespace Rcpp;
using namespace std;


// cf www.boost.org/doc/libs/1_53_0/libs/regex/example/snippets/credit_card_example.cpp


bool validate_card_format(const std::string& s) {
   static const boost::regex e("(\\d{4}[- ]){3}\\d{4}");
   return boost::regex_match(s, e);
}

const boost::regex e("\\A(\\d{3,4})[- ]?(\\d{4})[- ]?(\\d{4})[- ]?(\\d{4})\\z");
const std::string machine_format("\\1\\2\\3\\4");
const std::string human_format("\\1-\\2-\\3-\\4");

const boost::regex re_digits2 ("[[:digit:]]");
const boost::regex re_punct2("[[:punct:]]");
const boost::regex re_twitter2("(^|\\s)(#|@)\\S+");
const boost::regex re_url2("(?i)\\b((?:[a-z][\\w-]+:(?:/{1,3}|[a-z0-9%])|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:\\'\".,<>?]))");
const boost::regex re_multipleSpaces("\\s{2,}");
const std::string space (" ");
const std::string empty ("");


std::string machine_readable_card_number(const std::string& s) {
   return boost::regex_replace(s, e, machine_format, boost::match_default | boost::format_sed);
}

std::string human_readable_card_number(const std::string& s) {
   return boost::regex_replace(s, e, human_format, boost::match_default | boost::format_sed);
}

// [[Rcpp::export]]
Rcpp::DataFrame regexDemo(std::vector<std::string> s) {
    int n = s.size();
    
    std::vector<bool> valid(n);
    std::vector<std::string> machine(n);
    std::vector<std::string> human(n);
    
    for (int i=0; i<n; i++) {
        valid[i]  = validate_card_format(s[i]);
        machine[i] = machine_readable_card_number(s[i]);
        human[i] = human_readable_card_number(s[i]);
    }
    return Rcpp::DataFrame::create(Rcpp::Named("input") = s,
                                   Rcpp::Named("valid") = valid,
                                   Rcpp::Named("machine") = machine,
                                   Rcpp::Named("human") = human);
}
