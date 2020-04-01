import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviesdb/Models/ByPerson.dart';
import 'package:themoviesdb/Models/Credits.dart';
import 'package:themoviesdb/Models/Person.dart';
import 'package:themoviesdb/Models/SeasonInfo.dart';
import 'package:themoviesdb/Models/TVShow.dart';
import 'package:themoviesdb/Models/inShortModel/InMovieShortInfo.dart';
import 'package:themoviesdb/Models/inShortModel/InShortGenreList.dart';
import 'package:themoviesdb/Models/inShortModel/InTVShortInfo.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Constants.dart';

class Helper {
  static Map<int, Color> color = {
    50: Color.fromRGBO(4, 131, 184, .1),
    100: Color.fromRGBO(4, 131, 184, .2),
    200: Color.fromRGBO(4, 131, 184, .3),
    300: Color.fromRGBO(4, 131, 184, .4),
    400: Color.fromRGBO(4, 131, 184, .5),
    500: Color.fromRGBO(4, 131, 184, .6),
    600: Color.fromRGBO(4, 131, 184, .7),
    700: Color.fromRGBO(4, 131, 184, .8),
    800: Color.fromRGBO(4, 131, 184, .9),
    900: Color.fromRGBO(4, 131, 184, 1),
  };

  static loadImage(String url, double mHeight, double mWidth, BuildContext context, BoxFit boxFit) {
    return Container(
      constraints: new BoxConstraints.expand(height: mHeight),
      child: CachedNetworkImage(
          imageUrl: url,
          width: mWidth,
          height: mHeight,
          fit: boxFit,
          placeholder: (
            context,
            url,
          ) =>
              Image(
                width: mWidth,
                height: mHeight,
                image: ExactAssetImage('assets/images/loading.gif'),
                fit: boxFit,
              )),
    );
  }

  static loadCircleImage(String url, double mHeight, double mWidth, BuildContext context, BoxFit boxFit) {
    return CachedNetworkImage(
        imageUrl: url,
        width: mWidth,
        height: mHeight,
        fit: boxFit,
        placeholder: (
          context,
          url,
        ) =>
            Image(
              width: mWidth,
              height: mHeight,
              image: ExactAssetImage('assets/images/loading.gif'),
              fit: boxFit,
            ));
  }

  static String getExactInResumeTitle(String name) {
    if (name.contains('('))
      return name.split("(")[0];
    else
      return name;
  }

  static getExactTime(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}h:${minutes.toString().padLeft(2, "0")}min';
  }

  static getExactCurrency(int currency) {
    if (currency == 0)
      return "N/V";
    else
      return NumberFormat.compactCurrency(
        decimalDigits: 2,
        symbol: "\$",
      ).format(currency);
  }

  static getExactDateWithoutDay(DateTime date) {
    if (date != null)
      return '' + DateFormat("d, MMM, yyyy").format(date);
    else
      return 'N/A';
  }

  static String getExactRatingPercentage(double voteAverage) {
    voteAverage = voteAverage * 10;
    return "${voteAverage}%";
  }

  static getExactRatingColor(double voteAverage) {
    if (voteAverage >= 6.5)
      return MaterialColor(0xFF01d277, Helper.color);
    else if (voteAverage > 5.0 && voteAverage < 6.5)
      return MaterialColor(0xFFd2d531, Helper.color);
    else
      return MaterialColor(0xFFf2f558, Helper.color);
  }

  static String getWorkingImage(String profilePath, int gender) {
    if (profilePath == null || profilePath.isEmpty) {
      return getExactNoProfile(gender);
    } else {
      return image_large + profilePath;
    }
  }

  static String getWorkingImagetmp(String profilePath, int gender) {
    if (profilePath == null || profilePath.isEmpty) {
      return getExactNoProfile(gender);
    } else {
      return image_large + profilePath;
    }
  }

  static String getExactNoProfile(int gender) {
    if (gender == 0 || gender == 2)
      return no_profile_male;
    else
      return no_profile_female;
  }

  static getYoutubeThumbnail(String key, BuildContext context, double mHeight) {
    return Container(
      color: Colors.black,
      height: mHeight,
      child: CachedNetworkImage(
          errorWidget: (context, url, error) => Image(fit: BoxFit.cover, height: mHeight, image: ExactAssetImage('assets/images/no_video.png')),
          imageUrl: thumbnail_youtube + key + resolution_max,
          fit: BoxFit.fitHeight,
          placeholder: (
            context,
            url,
          ) {
            return Image(
              width: MediaQuery.of(context).size.width,
              height: mHeight,
              image: ExactAssetImage('assets/images/loading.gif'),
              fit: BoxFit.cover,
            );
          }),
    );
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static getCompanyWorkingImage(String logoPath, BuildContext context) {
    if (logoPath != null && logoPath.isNotEmpty) {
      return SizedBox(
          width: 60,
          height: 60,
          child: CachedNetworkImage(
            errorWidget: (context, url, error) => Image(fit: BoxFit.cover, height: 50, image: ExactAssetImage('assets/images/no_video.png')),
            imageUrl: image_large + logoPath,
            fit: BoxFit.scaleDown,
          ));
    } else {
      return SizedBox(
          width: 60, height: 60, child: Padding(padding: EdgeInsets.all(16.0), child: loadImage(no_company, 50, 50, context, BoxFit.scaleDown)));
    }
  }

  //<Trending>
  static String getExactTitleTrending(AsyncSnapshot snapshot, int index) {
    if (snapshot.data.results[index].title != null)
      return snapshot.data.results[index].title;
    else if (snapshot.data.results[index].originalTitle != null)
      return snapshot.data.results[index].originalTitle;
    else if (snapshot.data.results[index].name != null)
      return snapshot.data.results[index].name;
    else
      return snapshot.data.results[index].originalName; //2
  }

  static String getExactName(AsyncSnapshot snapshot, int index) {
    if (snapshot.data.results != null) {
      if (snapshot.data.results[index].name != null)
        return snapshot.data.results[index].name;
      else if (snapshot.data.results[index].originalName != null)
        return snapshot.data.results[index].originalName;
      else
        return 'No name available';
    } else
      return 'No name available';
  }

  static getExactRating(String voteAverage) {
    if (double.parse(voteAverage) > 7.0) {
      return Icon(Icons.star, size: 12, color: Colors.black87);
    } else {
      return Icon(Icons.star_half, size: 12, color: Colors.black87);
    }
  }

  static getInTVShortInfo(AsyncSnapshot snapshot, int index) {
    var data = snapshot.data.results[index];
    if (data.posterPath.isEmpty || data.posterPath == null) data.posterPath = 'https://i.imgur.com/N2CjNhQ.png'; //PLACEHOLDER

    if (data.backdropPath.isEmpty || data.backdropPath == null) data.backdropPath = 'https://i.imgur.com/N2CjNhQ.png'; //PLACEHOLDER

    if (data.overview.isEmpty || data.overview == null) data.overview = help_tmvdb;

    if (data.voteAverage == 0 || data.voteAverage == null) data.voteAverage = 0;

    return InTVShortInfo(getExactName(snapshot, index), getExactName(snapshot, index), data.popularity, data.voteCount, data.firstAirDate,
        data.backdropPath, data.id, data.voteAverage, data.overview, data.posterPath);
  }

  static getInMovieShortInfo(AsyncSnapshot snapshot, int index) {
    var data = snapshot.data.results[index];
    if (data.posterPath.isEmpty || data.posterPath == null) data.posterPath = 'https://i.imgur.com/N2CjNhQ.png'; //PLACEHOLDER

    if (data.backdropPath.isEmpty || data.backdropPath == null) data.backdropPath = 'https://i.imgur.com/N2CjNhQ.png'; //PLACEHOLDER

    if (data.overview.isEmpty || data.overview == null) data.overview = help_tmvdb;

    if (data.voteAverage == 0 || data.voteAverage == null) data.voteAverage = 0;

    return InMovieShortInfo(data.popularity, data.voteCount, data.video, data.posterPath, data.id, data.adult, data.backdropPath, data.originalTitle,
        data.genreIds, data.title, data.voteAverage, data.overview, data.releaseDate);
  }

  static getInMovieShortInfoByPerson(List<dynamic> list, int index) {
    var data = list[index];
    if (data.posterPath.isEmpty || data.posterPath == null) data.posterPath = 'https://i.imgur.com/N2CjNhQ.png'; //PLACEHOLDER

    if (data.backdropPath.isEmpty || data.backdropPath == null) data.backdropPath = 'https://i.imgur.com/N2CjNhQ.png'; //PLACEHOLDER

    if (data.overview.isEmpty || data.overview == null) data.overview = help_tmvdb;

    if (data.voteAverage == 0 || data.voteAverage == null) data.voteAverage = 0;

    return InMovieShortInfo(data.popularity, data.voteCount, data.video, data.posterPath, data.id, data.adult, data.backdropPath, data.originalTitle,
        data.genreIds, data.title, data.voteAverage, data.overview, DateTime.parse(data.releaseDate));
  }

  static String getExactGenres(List<int> genresIds, int index, List<InShortGenreList> genreList) {
    List<String> genresNameList = [];
    List<int> genresIdList = genresIds;
    if (genreList.length > 0) {
      genreList.add(InShortGenreList(id: 10759, name: 'Action & Adventure'));
      genreList.add(InShortGenreList(id: 10764, name: 'Reality'));
      genreList.add(InShortGenreList(id: 10762, name: 'Kids'));
      genreList.add(InShortGenreList(id: 10763, name: 'News'));
      genreList.add(InShortGenreList(id: 10765, name: 'Sci-Fi & Fantasy'));
      genreList.add(InShortGenreList(id: 10766, name: 'Soap'));
      genreList.add(InShortGenreList(id: 10767, name: 'Talk'));
      genreList.add(InShortGenreList(id: 10768, name: 'War & Politics'));
      for (int i = 0; i < genreList.length; i++) {
        for (var genreId in genresIdList) {
          if (genreId == genreList[i].id) {
            genresNameList.add(genreList[i].name);
          }
        }
      }
      return genresNameList.toString();
    } else
      return ' ';
  }

  static showToast(String msg, BuildContext context) {
    Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  static getExactDateYearOnly(DateTime dateTime) {
    if (dateTime != null)
      return '' + DateFormat("yyyy").format(dateTime);
    else
      return 'N/A';
  }

  static getExactRadiusValue(double value) {
    return BorderRadius.only(
      topLeft: Radius.circular(0.0),
      topRight: Radius.circular(0.0),
      bottomLeft: Radius.circular(value),
      bottomRight: Radius.circular(value),
    );
  }

  /**ALL METHODS TO HANDLE NULL JSON OBJECTS**/

  static getNextEpisode(TEpisodeToAir nextEpisodeToAir, String msg, bool withDay) {
    if (nextEpisodeToAir == null) {
      return msg;
    } else {
      if (withDay)
        return Helper.getExactDateDay(nextEpisodeToAir.airDate);
      else
        return Helper.getExactDateWithoutDay(nextEpisodeToAir.airDate);
    }
  }

  static String getExactCover(AsyncSnapshot snapshot, int index) {
    if (snapshot.data.results != null && snapshot.data.results[index].backdropPath != null)
      return image_original + snapshot.data.results[index].backdropPath;
    else
      return no_cover;
  }

  static String getExactPoster(AsyncSnapshot snapshot, int index) {
    if (snapshot.data.results != null && snapshot.data.results[index].posterPath != null)
      return image_large + snapshot.data.results[index].posterPath;
    else
      return no_poster;
  }

  static String getExactTitle(AsyncSnapshot snapshot, int index) {
    if (snapshot.data.results != null) {
      if (snapshot.data.results[index].title != null)
        return snapshot.data.results[index].title;
      else if (snapshot.data.results[index].originalTitle != null)
        return snapshot.data.results[index].originalTitle;
      else
        return 'No title available';
    } else {
      return 'No title available';
    }
  }

  static String getExactDateDay(DateTime dateTime) {
    if (dateTime != null) {
      final now = DateTime.now();
      int difference = now.difference(dateTime).inDays;
      difference = difference * -1;
      if (difference.toString() == '0')
        return 'New episode airs today';
      else if (difference.toString() == '1')
        return 'New episode airs tomorrow';
      else
        return 'New episode airs in ' + difference.toString() + ' days';
    } else {
      return 'No information available';
    }
  }

  static String getExactDate(AsyncSnapshot snapshot, int index) {
    if (snapshot.data.results != null) {
      if (snapshot.data.results[index] != null)
        return '${DateFormat("EEEE, d MMM, yyyy").format(snapshot.data.results[index].releaseDate)}';
      else
        return 'No release date available';
    } else
      return 'No release date available';
  }

  static String getExactRatingValue(AsyncSnapshot snapshot, int index) {
    if (snapshot.data.results != null) {
      if (snapshot.data.results[index].voteAverage != null)
        return snapshot.data.results[index].voteAverage.toString();
      else
        return '0.0';
    } else
      return '0.0';
  }

  static double getExactEpisodeVoteAverage(AsyncSnapshot snapshot, int index) {
    if (snapshot.data.episodes != null) {
      if (snapshot.data.episodes[index].voteAverage != null)
        return snapshot.data.episodes[index].voteAverage;
      else
        return 0.0;
    } else
      return 0.0;
  }

  static double getExactVoteAverage(AsyncSnapshot snapshot, int index) {
    if (snapshot.data.results != null) {
      if (snapshot.data.results[index].voteAverage != null)
        return snapshot.data.results[index].voteAverage;
      else
        return 0.0;
    } else
      return 0.0;
  }

  static getExactTitleName(AsyncSnapshot snapshot, int index) {
    if (getExactTitle(snapshot, index) != 'No title available')
      return getExactTitle(snapshot, index);
    else if (getExactName(snapshot, index) != 'No name available')
      return getExactName(snapshot, index);
    else {
      return 'No title available2';
    }
  }

  static getExactOverview(AsyncSnapshot snapshot, int index) {
    if (snapshot.data.results != null) {
      if (snapshot.data.results[index].overview != null && snapshot.data.results[index].overview.isNotEmpty)
        return snapshot.data.results[index].overview.toString();
      else
        return no_overview;
    } else
      return no_overview;
  }

  static String getCastProfilePicture(AsyncSnapshot<Credits> snapshot, int index) {
    if (snapshot.data.cast != null) {
      if (snapshot.data.cast[index].profilePath != null && snapshot.data.cast[index].profilePath.isNotEmpty) {
        return image_large + snapshot.data.cast[index].profilePath;
      } else {
        return getExactProfilePictureGender(snapshot, index, Jobs.CAST);
      }
    } else
      return getExactProfilePictureGender(snapshot, index, Jobs.CAST);
  }

  static String getCrewProfilePicture(AsyncSnapshot<Credits> snapshot, int index) {
    if (snapshot.data.crew != null) {
      if (snapshot.data.crew[index].profilePath != null && snapshot.data.crew[index].profilePath.isNotEmpty) {
        return image_large + snapshot.data.crew[index].profilePath;
      } else {
        return getExactProfilePictureGender(snapshot, index, Jobs.CAST);
      }
    } else
      return getExactProfilePictureGender(snapshot, index, Jobs.CAST);
  }

  static String getExactProfilePictureGender(AsyncSnapshot snapshot, int index, Jobs job) {
    if (job == Jobs.CAST) {
      if (snapshot.data.cast[index].gender != null) {
        if (snapshot.data.cast[index].gender == 0 || snapshot.data.cast[index].gender == 2)
          return no_profile_male;
        else
          return no_profile_female;
      } else
        return no_profile_male;
    } else {
      if (snapshot.data.crew[index].gender != null) {
        if (snapshot.data.crew[index].gender == 0 || snapshot.data.crew[index].gender == 2)
          return no_profile_male;
        else
          return no_profile_female;
      } else
        return no_profile_male;
    }
  }

  static String getExactBio(String bio, String name) {
    if (bio == null || bio.isEmpty)
      return help_tmvdb_bio + name;
    else
      return bio;
  }

  static String getExactCreditsTitleName(AsyncSnapshot<ByPerson> snapshot, int index, Jobs job) {
    if (job == Jobs.CAST) {
      if (snapshot.data.cast != null) {
        if (snapshot.data.cast[index].title != null)
          return snapshot.data.cast[index].title;
        else if (snapshot.data.cast[index].originalTitle != null)
          return snapshot.data.cast[index].originalTitle;
        else if (snapshot.data.cast[index].name != null)
          return snapshot.data.cast[index].name;
        else
          return snapshot.data.cast[index].originalName;
      } else
        return 'No title available';
    } else {
      if (snapshot.data.crew != null) {
        if (snapshot.data.crew[index].title != null)
          return snapshot.data.crew[index].title;
        else if (snapshot.data.crew[index].originalTitle != null)
          return snapshot.data.crew[index].originalTitle;
        else if (snapshot.data.crew[index].name != null)
          return snapshot.data.crew[index].name;
        else
          return snapshot.data.crew[index].originalName;
      } else
        return 'No title available';
    }
  }

  static getExactEpisodeTime(List<int> episodeRunTime) {
    int hour, minutes;
    if (episodeRunTime != null && episodeRunTime.length > 0) {
      for (var ep in episodeRunTime) {
        if (ep != null && ep != 0) {
          hour = ep ~/ 60;
          minutes = ep % 60;
          break;
        }
      }
    } else
      return 'N/A';
    return '${hour.toString().padLeft(2, "0")}h:${minutes.toString().padLeft(2, "0")}min';
  }

  static getExactNetworks(List<Network> networks) {
    List<String> networksNamesList = [];
    if (networks != null && networks.length > 0)
      networks.forEach((network) {
        if (network.name != null && network.name.isNotEmpty) networksNamesList.add(network.name);
      });
    String networksNames = networksNamesList.toString().replaceAll('[', '').replaceAll(']', '');
    if (networksNames.isNotEmpty)
      return networksNames;
    else
      return 'N/A';
  }

/*SEASON*/
  static String getExactSeasonPoster(String posterPath) {
    if (posterPath != null && posterPath.isNotEmpty)
      return image_large + posterPath;
    else
      return no_poster;
  }

  static getExactSeasonOverview(String overview) {
    if (overview != null) {
      if (overview.isNotEmpty)
        return overview;
      else
        return no_overview;
    } else
      return no_overview;
  }

  static String getExactSeasonStillPath(AsyncSnapshot<SeasonInfo> snapshot, int index) {
    if (snapshot.data.episodes == null || snapshot.data.episodes.length <= 0) {
      return no_cover;
    } else if (snapshot.data.episodes[index].stillPath != null && snapshot.data.episodes[index].stillPath.isNotEmpty)
      return image_original + snapshot.data.episodes[index].stillPath;
    else
      return no_cover;
  }

  static String getExactSeasonRatingValue(AsyncSnapshot<SeasonInfo> snapshot, int index) {
    if (snapshot.data.episodes != null) {
      if (snapshot.data.episodes[index].voteAverage != null)
        return snapshot.data.episodes[index].voteAverage.toString();
      else
        return '0.0';
    } else
      return '0.0';
  }

  static getExactSeasonEpisodeName(AsyncSnapshot<SeasonInfo> snapshot, int index) {
    if (snapshot.data.episodes != null || snapshot.data.episodes.length > 0) {
      if (snapshot.data.episodes[index].name != null && snapshot.data.episodes[index].name.isNotEmpty)
        return snapshot.data.episodes[index].name;
      else
        return 'Episode ${index + 1} ';
    } else
      return 'Episode ${index + 1} ';
  }

/**/

  static String getExactProfilePicture(AsyncSnapshot<Person> snapshot) {
    if (snapshot.data.profilePath != null && snapshot.data.profilePath.isNotEmpty) {
      return image_large + snapshot.data.profilePath;
    } else {
      if (snapshot.data.gender != null) {
        if (snapshot.data.gender == 0 || snapshot.data.gender == 2)
          return no_profile_male;
        else
          return no_profile_female;
      } else {
        return no_profile_male;
      }
    }
  }

  static String getExactCreditsPoster(AsyncSnapshot<ByPerson> snapshot, int index, Jobs job) {
    if (job == Jobs.CAST) {
      if (snapshot.data.cast != null) {
        if (snapshot.data.cast[index].posterPath == null || snapshot.data.cast[index].posterPath.isEmpty) {
          return no_cover;
        } else {
          return image_large + snapshot.data.cast[index].posterPath;
        }
      } else
        return no_cover;
    } else {
      if (snapshot.data.crew != null) {
        if (snapshot.data.crew[index].posterPath == null || snapshot.data.crew[index].posterPath.isEmpty) {
          return no_cover;
        } else {
          return image_large + snapshot.data.crew[index].posterPath;
        }
      } else
        return no_cover;
    }
  }

  static getExactCreditsCover(AsyncSnapshot<ByPerson> snapshot, int index, Jobs job) {
    if (job == Jobs.CAST) {
      if (snapshot.data.cast != null) {
        if (snapshot.data.cast[index].backdropPath == null || snapshot.data.cast[index].backdropPath.isEmpty) {
          return no_cover;
        } else {
          return image_large + snapshot.data.cast[index].backdropPath;
        }
      } else
        return no_cover;
    } else {
      if (snapshot.data.crew != null) {
        if (snapshot.data.crew[index].backdropPath == null || snapshot.data.crew[index].backdropPath.isEmpty) {
          return no_cover;
        } else {
          return image_large + snapshot.data.crew[index].backdropPath;
        }
      } else
        return no_cover;
    }
  }

  static getExactCreditsOverview(AsyncSnapshot<ByPerson> snapshot, int index, Jobs job) {
    if (job == Jobs.CAST) {
      if (snapshot.data.cast != null && snapshot.data.cast[index].overview != null)
        return snapshot.data.cast[index].overview;
      else
        return no_overview;
    } else {
      if (snapshot.data.crew != null && snapshot.data.crew[index].overview != null)
        return snapshot.data.crew[index].overview;
      else
        return no_overview;
    }
  }

  static getExactCreditVoteAverage(AsyncSnapshot<ByPerson> snapshot, int index, Jobs job) {
    if (job == Jobs.CAST) {
      if (snapshot.data.cast != null) {
        if (snapshot.data.cast[index].voteAverage != null)
          return snapshot.data.cast[index].voteAverage;
        else
          return 0.0;
      } else
        return 0.0;
    } else {
      if (snapshot.data.crew != null) {
        if (snapshot.data.crew[index].voteAverage != null)
          return snapshot.data.crew[index].voteAverage;
        else
          return 0.0;
      } else
        return 0.0;
    }
  }
}

enum Jobs { CREW, CAST }
