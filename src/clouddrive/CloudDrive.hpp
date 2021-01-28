#ifndef _FEEDS_CLOUD_DRIVE_HPP_
#define _FEEDS_CLOUD_DRIVE_HPP_

#include <memory>

namespace trinity {

class CloudDrive {
public:
    /*** type define ***/
    enum Type {
        OneDrive,
    };

    /*** static function and variable ***/
    static std::shared_ptr<CloudDrive> Create(Type type,
                                              const std::string& driveUrl,
                                              const std::string& driveRootDir,
                                              const std::string& accessToken);

    /*** class function and variable ***/
    virtual int makeDir(const std::string& dirPath) = 0;
    virtual int remove(const std::string& filePath) = 0;
    virtual int write(const std::string& filePath, std::shared_ptr<std::istream> content) = 0;

protected:
    /*** type define ***/

    /*** static function and variable ***/

    /*** class function and variable ***/
    explicit CloudDrive() = default;
    virtual ~CloudDrive() = default;

private:
    /*** type define ***/

    /*** static function and variable ***/

    /*** class function and variable ***/

};

/***********************************************/
/***** class template function implement *******/
/***********************************************/

/***********************************************/
/***** macro definition ************************/
/***********************************************/

} // namespace trinity

#endif /* _FEEDS_CLOUD_DRIVE_HPP_ */

