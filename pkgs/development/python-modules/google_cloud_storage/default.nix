{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder
, google_api_core, google_auth, google-cloud-iam, google_cloud_core
, google_cloud_kms, google_cloud_testutils, google_resumable_media, mock
, requests }:

buildPythonPackage rec {
  pname = "google-cloud-storage";
  version = "1.33.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "900ba027bdee6b97f21cd22d1db3d1a6233ede5de2db4754db860438bdad72d2";
  };

  disabled = pythonOlder "3.5";

  propagatedBuildInputs = [
    google_api_core
    google_auth
    google_cloud_core
    google_resumable_media
    requests
  ];
  checkInputs = [
    google-cloud-iam
    google_cloud_kms
    google_cloud_testutils
    mock
    pytestCheckHook
  ];

  # disable tests which require credentials
  disabledTests = [ "create" "get" "post" "test_build_api_url" ];

  # prevent google directory from shadowing google imports
  # remove tests which require credentials
  preCheck = ''
    rm -r google
    rm tests/system/test_system.py tests/unit/test_client.py
  '';

  meta = with lib; {
    description = "Google Cloud Storage API client library";
    homepage = "https://github.com/googleapis/python-storage";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
