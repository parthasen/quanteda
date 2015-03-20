library(Rcpp)


Sys.setenv(PKG_LIBS = "-lpcrecpp")
sourceCpp(code = '
          #include <Rcpp.h> // Rcpp 0.11.3
          #include <pcrecpp.h> // pcrecpp 8.36

          // [[Rcpp::export]]
          Rcpp::String regexquote(Rcpp::String pattern) {
            return pcrecpp::RE::QuoteMeta(pattern.get_cstring());
          }
          class Regex {

            public:
            pcrecpp::RE re;

            Regex(Rcpp::String pattern) : re("(" + std::string(pattern) + ")", pcrecpp::UTF8()) {
              if (!re.error().empty()) {
                Rcpp::stop("Invalid regular expression: " + re.error());
              }
            }

            ~Regex() {}

            Rcpp::List scan(Rcpp::String str) {
              std::vector<std::vector<std::string> > all_matches;
              pcrecpp::StringPiece input(str.get_cstring());
              int n = re.NumberOfCapturingGroups();
              pcrecpp::Arg** args = new pcrecpp::Arg*[n];
              pcrecpp::Arg* match_ptrs = new pcrecpp::Arg[n];
              std::string* matches = new std::string[n];
              for (int i = 0; i < n; ++i) {
                match_ptrs[i] = &matches[i];
                args[i] = &match_ptrs[i];
              }
              int consumed;
              while (re.DoMatch(input, pcrecpp::RE::UNANCHORED, &consumed, args, n)) {
                all_matches.push_back(std::vector<std::string>(matches, matches + n));
                input.remove_prefix(consumed);
              }
              delete[] args;
              delete[] match_ptrs;
              delete[] matches;
              return Rcpp::wrap(all_matches);
            }
          };

          RCPP_MODULE(Regex) {
          Rcpp::class_<Regex>("Regex")
            .constructor<Rcpp::String>()
            .method("scan", &Regex::scan);
          } 
')