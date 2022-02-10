['pragma solidity ^0.5.2;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     * @notice Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev give an account access to this role\n', '     */\n', '    function add(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(!has(role, account));\n', '\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev remove an account's access to this role\n", '     */\n', '    function remove(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(has(role, account));\n', '\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev check if an account has this role\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0));\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', 'contract PauserRole {\n', '    using Roles for Roles.Role;\n', '\n', '    event PauserAdded(address indexed account);\n', '    event PauserRemoved(address indexed account);\n', '\n', '    Roles.Role private _pausers;\n', '\n', '    constructor () internal {\n', '        _addPauser(msg.sender);\n', '    }\n', '\n', '    modifier onlyPauser() {\n', '        require(isPauser(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isPauser(address account) public view returns (bool) {\n', '        return _pausers.has(account);\n', '    }\n', '\n', '    function addPauser(address account) public onlyPauser {\n', '        _addPauser(account);\n', '    }\n', '\n', '    function renouncePauser() public {\n', '        _removePauser(msg.sender);\n', '    }\n', '\n', '    function _addPauser(address account) internal {\n', '        _pausers.add(account);\n', '        emit PauserAdded(account);\n', '    }\n', '\n', '    function _removePauser(address account) internal {\n', '        _pausers.remove(account);\n', '        emit PauserRemoved(account);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is PauserRole {\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @return true if the contract is paused, false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() public onlyPauser whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() public onlyPauser whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', '/** @title ProofBox. */\n', 'contract ProofBox is Ownable, Pausable {\n', '\n', '    struct Device {\n', '      uint index;\n', '      address deviceOwner;\n', '      address txOriginator;\n', '\n', '    }\n', '\n', '    mapping (bytes32 => Device) private deviceMap;\n', '    mapping (address => bool) public authorized;\n', '    bytes32[] public deviceIds;\n', '\n', '\n', '\n', '    event deviceCreated(bytes32 indexed deviceId, address indexed deviceOwner);\n', '    event txnCreated(bytes32 indexed deviceId, address indexed txnOriginator);\n', '    event deviceProof(bytes32 indexed deviceId, address indexed deviceOwner);\n', '    event deviceTransfer(bytes32 indexed deviceId, address indexed fromOwner, address indexed toOwner);\n', '    event deviceMessage(bytes32 indexed deviceId, address indexed deviceOwner, address indexed txnOriginator, string messageToWrite);\n', '    event deviceDestruct(bytes32 indexed deviceId, address indexed deviceOwner);\n', '    event ipfsHashtoAddress(bytes32 indexed deviceId, address indexed ownerAddress, string ipfskey);\n', '\n', '\n', '\n', '    /** @dev Checks to see if device exist\n', '      * @param _deviceId ID of the device.\n', '      * @return isIndeed True if the device ID exists.\n', '      */\n', '    function isDeviceId(bytes32 _deviceId)\n', '       public\n', '       view\n', '       returns(bool isIndeed)\n', '     {\n', '       if(deviceIds.length == 0) return false;\n', '       return (deviceIds[deviceMap[_deviceId].index] == _deviceId);\n', '     }\n', '\n', '    /** @dev returns the index of stored deviceID\n', '      * @param _deviceId ID of the device.\n', '      * @return _index index of the device.\n', '      */\n', '    function getDeviceId(bytes32 _deviceId)\n', '       public\n', '       view\n', '       deviceIdExist(_deviceId)\n', '       returns(uint _index)\n', '     {\n', '       return deviceMap[_deviceId].index;\n', '     }\n', '\n', '     /** @dev returns address of device owner\n', '       * @param _deviceId ID of the device.\n', "       * @return deviceOwner device owner's address\n", '       */\n', '      function getOwnerByDevice(bytes32 _deviceId)\n', '           public\n', '           view\n', '           returns (address deviceOwner){\n', '\n', '               return deviceMap[_deviceId].deviceOwner;\n', '\n', '      }\n', '\n', '      /** @dev returns up to 10 devices for the device owner\n', "        * @return _deviceIds device ID's of the owner\n", '        */\n', '      function getDevicesByOwner(bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)\n', '              public\n', '              view\n', '              returns(bytes32[10] memory _deviceIds) {\n', '\n', '          address signer = ecrecover(_message, _v, _r, _s);\n', '          uint numDevices;\n', '          bytes32[10] memory devicesByOwner;\n', '\n', '          for(uint i = 0; i < deviceIds.length; i++) {\n', '\n', '              if(addressEqual(deviceMap[deviceIds[i]].deviceOwner,signer)) {\n', '\n', '                  devicesByOwner[numDevices] = deviceIds[i];\n', '                  if (numDevices == 10) {\n', '                    break;\n', '                  }\n', '                  numDevices++;\n', '\n', '              }\n', '\n', '          }\n', '\n', '          return devicesByOwner;\n', '      }\n', '\n', '      /** @dev returns up to 10 transactions of device owner\n', "        * @return _deviceIds device ID's of the msg.sender transactions\n", '        */\n', '      function getDevicesByTxn(bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)\n', '              public\n', '              view\n', '              returns(bytes32[10] memory _deviceIds) {\n', '\n', '          address signer = ecrecover(_message, _v, _r, _s);\n', '          uint numDevices;\n', '          bytes32[10] memory devicesByTxOriginator;\n', '\n', '          for(uint i = 0; i < deviceIds.length; i++) {\n', '\n', '              if(addressEqual(deviceMap[deviceIds[i]].txOriginator,signer)) {\n', '\n', '                  devicesByTxOriginator[numDevices] = deviceIds[i];\n', '                  if (numDevices == 10) {\n', '                    break;\n', '                  }\n', '                  numDevices++;\n', '\n', '              }\n', '\n', '          }\n', '\n', '          return devicesByTxOriginator;\n', '      }\n', '\n', '\n', '      modifier deviceIdExist(bytes32 _deviceId){\n', '          require(isDeviceId(_deviceId));\n', '          _;\n', '      }\n', '\n', '      modifier deviceIdNotExist(bytes32 _deviceId){\n', '          require(!isDeviceId(_deviceId));\n', '          _;\n', '      }\n', '\n', '      modifier authorizedUser() {\n', '          require(authorized[msg.sender] == true);\n', '          _;\n', '      }\n', '\n', '      constructor() public {\n', '\n', '          authorized[msg.sender]=true;\n', '      }\n', '\n', '\n', '    /** @dev when a new device ID is registered by a proxy owner by sending device owner signature\n', '      * @param _deviceId ID of the device.\n', '      * @return index of stored device\n', '      */\n', '    function registerProof (bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)\n', '         public\n', '         whenNotPaused()\n', '         authorizedUser()\n', '         deviceIdNotExist(_deviceId)\n', '         returns(uint index) {\n', '\n', '            address signer = ecrecover(_message, _v, _r, _s);\n', '\n', '            deviceMap[_deviceId].deviceOwner = signer;\n', '            deviceMap[_deviceId].txOriginator = signer;\n', '            deviceMap[_deviceId].index = deviceIds.push(_deviceId)-1;\n', '\n', '            emit deviceCreated(_deviceId, signer);\n', '\n', '            return deviceIds.length-1;\n', '\n', '    }\n', '\n', '    /** @dev returns true if delete is successful\n', '      * @param _deviceId ID of the device.\n', '      * @return bool delete\n', '      */\n', '    function destructProof(bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)\n', '            public\n', '            whenNotPaused()\n', '            authorizedUser()\n', '            deviceIdExist(_deviceId)\n', '            returns(bool success) {\n', '\n', '                address signer = ecrecover(_message, _v, _r, _s);\n', '\n', '                require(deviceMap[_deviceId].deviceOwner == signer);\n', '\n', '                uint rowToDelete = deviceMap[_deviceId].index;\n', '                bytes32 keyToMove = deviceIds[deviceIds.length-1];\n', '                deviceIds[rowToDelete] = keyToMove;\n', '                deviceMap[keyToMove].index = rowToDelete;\n', '                deviceIds.length--;\n', '\n', '                emit deviceDestruct(_deviceId, signer);\n', '                return true;\n', '\n', '    }\n', '\n', '    /** @dev returns request transfer of device\n', '      * @param _deviceId ID of the device.\n', '      * @return index of stored device\n', '      */\n', '    function requestTransfer(bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)\n', '          public\n', '          whenNotPaused()\n', '          deviceIdExist(_deviceId)\n', '          authorizedUser()\n', '          returns(uint index) {\n', '\n', '            address signer = ecrecover(_message, _v, _r, _s);\n', '\n', '            deviceMap[_deviceId].txOriginator=signer;\n', '\n', '            emit txnCreated(_deviceId, signer);\n', '\n', '            return deviceMap[_deviceId].index;\n', '\n', '    }\n', '\n', '    /** @dev returns approve transfer of device\n', '      * @param _deviceId ID of the device.\n', '      * @return bool approval\n', '      */\n', '    function approveTransfer (bytes32 _deviceId, address newOwner, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)\n', '            public\n', '            whenNotPaused()\n', '            deviceIdExist(_deviceId)\n', '            authorizedUser()\n', '            returns(bool) {\n', '\n', '                address signer = ecrecover(_message, _v, _r, _s);\n', '\n', '                require(deviceMap[_deviceId].deviceOwner == signer);\n', '                require(deviceMap[_deviceId].txOriginator == newOwner);\n', '\n', '                deviceMap[_deviceId].deviceOwner=newOwner;\n', '\n', '                emit deviceTransfer(_deviceId, signer, deviceMap[_deviceId].deviceOwner);\n', '\n', '                return true;\n', '\n', '    }\n', '\n', '    /** @dev returns write message success\n', '      * @param _deviceId ID of the device.\n', '      * @return bool true when write message is successful\n', '      */\n', '    function writeMessage (bytes32 _deviceId, string memory messageToWrite, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)\n', '            public\n', '            whenNotPaused()\n', '            deviceIdExist(_deviceId)\n', '            authorizedUser()\n', '            returns(bool) {\n', '                address signer = ecrecover(_message, _v, _r, _s);\n', '                require(deviceMap[_deviceId].deviceOwner == signer);\n', '                emit deviceMessage(_deviceId, deviceMap[_deviceId].deviceOwner, signer, messageToWrite);\n', '\n', '                return true;\n', '\n', '    }\n', '\n', '    /** @dev returns request proof of device\n', '      * @param _deviceId ID of the device.\n', '      * @return _index info of that device\n', '      */\n', '     function requestProof(bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)\n', '         public\n', '         whenNotPaused()\n', '         deviceIdExist(_deviceId)\n', '         authorizedUser()\n', '         returns(uint _index) {\n', '\n', '             address signer = ecrecover(_message, _v, _r, _s);\n', '\n', '             deviceMap[_deviceId].txOriginator=signer;\n', '\n', '             emit txnCreated(_deviceId, signer);\n', '\n', '             return deviceMap[_deviceId].index;\n', '     }\n', '\n', '\n', '     /** @dev returns approve proof of device\n', '       * @param _deviceId ID of the device.\n', '       * @return bool  - approval\n', '       */\n', '     function approveProof(bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)\n', '             public\n', '             whenNotPaused()\n', '             deviceIdExist(_deviceId)\n', '             authorizedUser()\n', '             returns(bool) {\n', '\n', '                  address signer = ecrecover(_message, _v, _r, _s);\n', '                  deviceMap[_deviceId].txOriginator=signer;\n', '                  require(deviceMap[_deviceId].deviceOwner == signer);\n', '\n', '                  emit deviceProof(_deviceId, signer);\n', '                  return true;\n', '     }\n', '\n', '     /** @dev updates IPFS hash into device owner public address\n', '       * @param ipfskey -  ipfs hash for attachment.\n', '       */\n', '     function emitipfskey(bytes32 _deviceId, address ownerAddress, string memory ipfskey)\n', '              public\n', '              whenNotPaused()\n', '              deviceIdExist(_deviceId)\n', '              authorizedUser() {\n', '        emit ipfsHashtoAddress(_deviceId, ownerAddress, ipfskey);\n', '    }\n', '\n', '    /** @dev Updates Authorization status of an address for executing functions\n', '    * on this contract\n', '    * @param target Address that will be authorized or not authorized\n', '    * @param isAuthorized New authorization status of address\n', '    */\n', '    function changeAuthStatus(address target, bool isAuthorized)\n', '            public\n', '            whenNotPaused()\n', '            onlyOwner() {\n', '\n', '              authorized[target] = isAuthorized;\n', '    }\n', '\n', '    /** @dev Updates Authorization status of an address for executing functions\n', '    * on this contract\n', '    * @param targets Address that will be authorized or not authorized in bulk\n', '    * @param isAuthorized New registration status of address\n', '    */\n', '    function changeAuthStatuses(address[] memory targets, bool isAuthorized)\n', '            public\n', '            whenNotPaused()\n', '            onlyOwner() {\n', '              for (uint i = 0; i < targets.length; i++) {\n', '                changeAuthStatus(targets[i], isAuthorized);\n', '              }\n', '    }\n', '\n', '    /*\n', '        NOTE: We explicitly do not define a fallback function, because there are\n', '        no ethers received by any funtion on this contract\n', '\n', '    */\n', '\n', '    //Helper Functions\n', '\n', '    /** @dev compares two String equal or not\n', '      * @param a first string, b second string.\n', '      * @return bool true if match\n', '      */\n', '    function bytesEqual(bytes32 a, bytes32 b) private pure returns (bool) {\n', '       return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));\n', '     }\n', '\n', '   /** @dev compares two address equal or not\n', '     * @param a first address, b second address.\n', '     * @return bool true if match\n', '     */\n', '   function addressEqual(address a, address b) private pure returns (bool) {\n', '      return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));\n', '    }\n', '\n', '}']