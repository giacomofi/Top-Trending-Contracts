['pragma solidity ^0.4.21;\n', '\n', 'library StringUtils {\n', '    // Tests for uppercase characters in a given string\n', '    function allLower(string memory _string) internal pure returns (bool) {\n', '        bytes memory bytesString = bytes(_string);\n', '        for (uint i = 0; i < bytesString.length; i++) {\n', '            if ((bytesString[i] >= 65) && (bytesString[i] <= 90)) {  // Uppercase characters\n', '                return false;\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Withdrawable is Ownable {\n', '    // Allows owner to withdraw ether from the contract\n', '    function withdrawEther(address to) public onlyOwner {\n', '        to.transfer(address(this).balance);\n', '    }\n', '\n', '    // Allows owner to withdraw ERC20 tokens from the contract\n', '    function withdrawERC20Token(address tokenAddress, address to) public onlyOwner {\n', '        ERC20Basic token = ERC20Basic(tokenAddress);\n', '        token.transfer(to, token.balanceOf(address(this)));\n', '    }\n', '}\n', '\n', '\n', 'interface HydroToken {\n', '    function balanceOf(address _owner) external returns (uint256 balance);\n', '}\n', '\n', '\n', 'contract RaindropClient is Withdrawable {\n', '    // Events for when a user signs up for Raindrop Client and when their account is deleted\n', '    event UserSignUp(string userName, address userAddress, bool official);\n', '    event UserDeleted(string userName, address userAddress, bool official);\n', '    // Events for when an application signs up for Raindrop Client and when their account is deleted\n', '    event ApplicationSignUp(string applicationName, bool official);\n', '    event ApplicationDeleted(string applicationName, bool official);\n', '\n', '    using StringUtils for string;\n', '\n', '    // Fees that unofficial users/applications must pay to sign up for Raindrop Client\n', '    uint public unofficialUserSignUpFee;\n', '    uint public unofficialApplicationSignUpFee;\n', '\n', '    address public hydroTokenAddress;\n', '    uint public hydroStakingMinimum;\n', '\n', '    // User accounts\n', '    struct User {\n', '        string userName;\n', '        address userAddress;\n', '        bool official;\n', '        bool _initialized;\n', '    }\n', '\n', '    // Application accounts\n', '    struct Application {\n', '        string applicationName;\n', '        bool official;\n', '        bool _initialized;\n', '    }\n', '\n', '    // Internally, users and applications are identified by the hash of their names\n', '    mapping (bytes32 => User) internal userDirectory;\n', '    mapping (bytes32 => Application) internal officialApplicationDirectory;\n', '    mapping (bytes32 => Application) internal unofficialApplicationDirectory;\n', '\n', '    // Allows the Hydro API to sign up official users with their app-generated address\n', '    function officialUserSignUp(string userName, address userAddress) public onlyOwner {\n', '        _userSignUp(userName, userAddress, true);\n', '    }\n', '\n', '    // Allows anyone to sign up as an unofficial user with their own address\n', '    function unofficialUserSignUp(string userName) public payable {\n', '        require(bytes(userName).length < 100);\n', '        require(msg.value >= unofficialUserSignUpFee);\n', '\n', '        return _userSignUp(userName, msg.sender, false);\n', '    }\n', '\n', '    // Allows the Hydro API to delete official users iff they&#39;ve signed keccak256("Delete") with their private key\n', '    function deleteUserForUser(string userName, uint8 v, bytes32 r, bytes32 s) public onlyOwner {\n', '        bytes32 userNameHash = keccak256(userName);\n', '        require(userNameHashTaken(userNameHash));\n', '        address userAddress = userDirectory[userNameHash].userAddress;\n', '        require(isSigned(userAddress, keccak256("Delete"), v, r, s));\n', '\n', '        delete userDirectory[userNameHash];\n', '\n', '        emit UserDeleted(userName, userAddress, true);\n', '    }\n', '\n', '    // Allows unofficial users to delete their account\n', '    function deleteUser(string userName) public {\n', '        bytes32 userNameHash = keccak256(userName);\n', '        require(userNameHashTaken(userNameHash));\n', '        address userAddress = userDirectory[userNameHash].userAddress;\n', '        require(userAddress == msg.sender);\n', '\n', '        delete userDirectory[userNameHash];\n', '\n', '        emit UserDeleted(userName, userAddress, true);\n', '    }\n', '\n', '    // Allows the Hydro API to sign up official applications\n', '    function officialApplicationSignUp(string applicationName) public onlyOwner {\n', '        bytes32 applicationNameHash = keccak256(applicationName);\n', '        require(!applicationNameHashTaken(applicationNameHash, true));\n', '        officialApplicationDirectory[applicationNameHash] = Application(applicationName, true, true);\n', '\n', '        emit ApplicationSignUp(applicationName, true);\n', '    }\n', '\n', '    // Allows anyone to sign up as an unofficial application\n', '    function unofficialApplicationSignUp(string applicationName) public payable {\n', '        require(bytes(applicationName).length < 100);\n', '        require(msg.value >= unofficialApplicationSignUpFee);\n', '        require(applicationName.allLower());\n', '\n', '        HydroToken hydro = HydroToken(hydroTokenAddress);\n', '        uint256 hydroBalance = hydro.balanceOf(msg.sender);\n', '        require(hydroBalance >= hydroStakingMinimum);\n', '\n', '        bytes32 applicationNameHash = keccak256(applicationName);\n', '        require(!applicationNameHashTaken(applicationNameHash, false));\n', '        unofficialApplicationDirectory[applicationNameHash] = Application(applicationName, false, true);\n', '\n', '        emit ApplicationSignUp(applicationName, false);\n', '    }\n', '\n', '    // Allows the Hydro API to delete applications unilaterally\n', '    function deleteApplication(string applicationName, bool official) public onlyOwner {\n', '        bytes32 applicationNameHash = keccak256(applicationName);\n', '        require(applicationNameHashTaken(applicationNameHash, official));\n', '        if (official) {\n', '            delete officialApplicationDirectory[applicationNameHash];\n', '        } else {\n', '            delete unofficialApplicationDirectory[applicationNameHash];\n', '        }\n', '\n', '        emit ApplicationDeleted(applicationName, official);\n', '    }\n', '\n', '    // Allows the Hydro API to changes the unofficial user fee\n', '    function setUnofficialUserSignUpFee(uint newFee) public onlyOwner {\n', '        unofficialUserSignUpFee = newFee;\n', '    }\n', '\n', '    // Allows the Hydro API to changes the unofficial application fee\n', '    function setUnofficialApplicationSignUpFee(uint newFee) public onlyOwner {\n', '        unofficialApplicationSignUpFee = newFee;\n', '    }\n', '\n', '    // Allows the Hydro API to link to the Hydro token\n', '    function setHydroContractAddress(address _hydroTokenAddress) public onlyOwner {\n', '        hydroTokenAddress = _hydroTokenAddress;\n', '    }\n', '\n', '    // Allows the Hydro API to set a minimum hydro balance required to register unofficially\n', '    function setHydroStakingMinimum(uint newMinimum) public onlyOwner {\n', '        hydroStakingMinimum = newMinimum;\n', '    }\n', '\n', '    // Indicates whether a given user name has been claimed\n', '    function userNameTaken(string userName) public view returns (bool taken) {\n', '        bytes32 userNameHash = keccak256(userName);\n', '        return userDirectory[userNameHash]._initialized;\n', '    }\n', '\n', '    // Indicates whether a given application name has been claimed for official and unofficial applications\n', '    function applicationNameTaken(string applicationName)\n', '        public\n', '        view\n', '        returns (bool officialTaken, bool unofficialTaken)\n', '    {\n', '        bytes32 applicationNameHash = keccak256(applicationName);\n', '        return (\n', '            officialApplicationDirectory[applicationNameHash]._initialized,\n', '            unofficialApplicationDirectory[applicationNameHash]._initialized\n', '        );\n', '    }\n', '\n', '    // Returns user details by user name\n', '    function getUserByName(string userName) public view returns (address userAddress, bool official) {\n', '        bytes32 userNameHash = keccak256(userName);\n', '        require(userNameHashTaken(userNameHash));\n', '        User storage _user = userDirectory[userNameHash];\n', '\n', '        return (_user.userAddress, _user.official);\n', '    }\n', '\n', '    // Checks whether the provided (v, r, s) signature was created by the private key associated with _address\n', '    function isSigned(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) public pure returns (bool) {\n', '        return ecrecover(messageHash, v, r, s) == _address;\n', '    }\n', '\n', '    // Common internal logic for all user signups\n', '    function _userSignUp(string userName, address userAddress, bool official) internal {\n', '        bytes32 userNameHash = keccak256(userName);\n', '        require(!userNameHashTaken(userNameHash));\n', '        userDirectory[userNameHash] = User(userName, userAddress, official, true);\n', '\n', '        emit UserSignUp(userName, userAddress, official);\n', '    }\n', '\n', '    // Internal check for whether a user name has been taken\n', '    function userNameHashTaken(bytes32 userNameHash) internal view returns (bool) {\n', '        return userDirectory[userNameHash]._initialized;\n', '    }\n', '\n', '    // Internal check for whether an application name has been taken\n', '    function applicationNameHashTaken(bytes32 applicationNameHash, bool official) internal view returns (bool) {\n', '        if (official) {\n', '            return officialApplicationDirectory[applicationNameHash]._initialized;\n', '        } else {\n', '            return unofficialApplicationDirectory[applicationNameHash]._initialized;\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'library StringUtils {\n', '    // Tests for uppercase characters in a given string\n', '    function allLower(string memory _string) internal pure returns (bool) {\n', '        bytes memory bytesString = bytes(_string);\n', '        for (uint i = 0; i < bytesString.length; i++) {\n', '            if ((bytesString[i] >= 65) && (bytesString[i] <= 90)) {  // Uppercase characters\n', '                return false;\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Withdrawable is Ownable {\n', '    // Allows owner to withdraw ether from the contract\n', '    function withdrawEther(address to) public onlyOwner {\n', '        to.transfer(address(this).balance);\n', '    }\n', '\n', '    // Allows owner to withdraw ERC20 tokens from the contract\n', '    function withdrawERC20Token(address tokenAddress, address to) public onlyOwner {\n', '        ERC20Basic token = ERC20Basic(tokenAddress);\n', '        token.transfer(to, token.balanceOf(address(this)));\n', '    }\n', '}\n', '\n', '\n', 'interface HydroToken {\n', '    function balanceOf(address _owner) external returns (uint256 balance);\n', '}\n', '\n', '\n', 'contract RaindropClient is Withdrawable {\n', '    // Events for when a user signs up for Raindrop Client and when their account is deleted\n', '    event UserSignUp(string userName, address userAddress, bool official);\n', '    event UserDeleted(string userName, address userAddress, bool official);\n', '    // Events for when an application signs up for Raindrop Client and when their account is deleted\n', '    event ApplicationSignUp(string applicationName, bool official);\n', '    event ApplicationDeleted(string applicationName, bool official);\n', '\n', '    using StringUtils for string;\n', '\n', '    // Fees that unofficial users/applications must pay to sign up for Raindrop Client\n', '    uint public unofficialUserSignUpFee;\n', '    uint public unofficialApplicationSignUpFee;\n', '\n', '    address public hydroTokenAddress;\n', '    uint public hydroStakingMinimum;\n', '\n', '    // User accounts\n', '    struct User {\n', '        string userName;\n', '        address userAddress;\n', '        bool official;\n', '        bool _initialized;\n', '    }\n', '\n', '    // Application accounts\n', '    struct Application {\n', '        string applicationName;\n', '        bool official;\n', '        bool _initialized;\n', '    }\n', '\n', '    // Internally, users and applications are identified by the hash of their names\n', '    mapping (bytes32 => User) internal userDirectory;\n', '    mapping (bytes32 => Application) internal officialApplicationDirectory;\n', '    mapping (bytes32 => Application) internal unofficialApplicationDirectory;\n', '\n', '    // Allows the Hydro API to sign up official users with their app-generated address\n', '    function officialUserSignUp(string userName, address userAddress) public onlyOwner {\n', '        _userSignUp(userName, userAddress, true);\n', '    }\n', '\n', '    // Allows anyone to sign up as an unofficial user with their own address\n', '    function unofficialUserSignUp(string userName) public payable {\n', '        require(bytes(userName).length < 100);\n', '        require(msg.value >= unofficialUserSignUpFee);\n', '\n', '        return _userSignUp(userName, msg.sender, false);\n', '    }\n', '\n', '    // Allows the Hydro API to delete official users iff they\'ve signed keccak256("Delete") with their private key\n', '    function deleteUserForUser(string userName, uint8 v, bytes32 r, bytes32 s) public onlyOwner {\n', '        bytes32 userNameHash = keccak256(userName);\n', '        require(userNameHashTaken(userNameHash));\n', '        address userAddress = userDirectory[userNameHash].userAddress;\n', '        require(isSigned(userAddress, keccak256("Delete"), v, r, s));\n', '\n', '        delete userDirectory[userNameHash];\n', '\n', '        emit UserDeleted(userName, userAddress, true);\n', '    }\n', '\n', '    // Allows unofficial users to delete their account\n', '    function deleteUser(string userName) public {\n', '        bytes32 userNameHash = keccak256(userName);\n', '        require(userNameHashTaken(userNameHash));\n', '        address userAddress = userDirectory[userNameHash].userAddress;\n', '        require(userAddress == msg.sender);\n', '\n', '        delete userDirectory[userNameHash];\n', '\n', '        emit UserDeleted(userName, userAddress, true);\n', '    }\n', '\n', '    // Allows the Hydro API to sign up official applications\n', '    function officialApplicationSignUp(string applicationName) public onlyOwner {\n', '        bytes32 applicationNameHash = keccak256(applicationName);\n', '        require(!applicationNameHashTaken(applicationNameHash, true));\n', '        officialApplicationDirectory[applicationNameHash] = Application(applicationName, true, true);\n', '\n', '        emit ApplicationSignUp(applicationName, true);\n', '    }\n', '\n', '    // Allows anyone to sign up as an unofficial application\n', '    function unofficialApplicationSignUp(string applicationName) public payable {\n', '        require(bytes(applicationName).length < 100);\n', '        require(msg.value >= unofficialApplicationSignUpFee);\n', '        require(applicationName.allLower());\n', '\n', '        HydroToken hydro = HydroToken(hydroTokenAddress);\n', '        uint256 hydroBalance = hydro.balanceOf(msg.sender);\n', '        require(hydroBalance >= hydroStakingMinimum);\n', '\n', '        bytes32 applicationNameHash = keccak256(applicationName);\n', '        require(!applicationNameHashTaken(applicationNameHash, false));\n', '        unofficialApplicationDirectory[applicationNameHash] = Application(applicationName, false, true);\n', '\n', '        emit ApplicationSignUp(applicationName, false);\n', '    }\n', '\n', '    // Allows the Hydro API to delete applications unilaterally\n', '    function deleteApplication(string applicationName, bool official) public onlyOwner {\n', '        bytes32 applicationNameHash = keccak256(applicationName);\n', '        require(applicationNameHashTaken(applicationNameHash, official));\n', '        if (official) {\n', '            delete officialApplicationDirectory[applicationNameHash];\n', '        } else {\n', '            delete unofficialApplicationDirectory[applicationNameHash];\n', '        }\n', '\n', '        emit ApplicationDeleted(applicationName, official);\n', '    }\n', '\n', '    // Allows the Hydro API to changes the unofficial user fee\n', '    function setUnofficialUserSignUpFee(uint newFee) public onlyOwner {\n', '        unofficialUserSignUpFee = newFee;\n', '    }\n', '\n', '    // Allows the Hydro API to changes the unofficial application fee\n', '    function setUnofficialApplicationSignUpFee(uint newFee) public onlyOwner {\n', '        unofficialApplicationSignUpFee = newFee;\n', '    }\n', '\n', '    // Allows the Hydro API to link to the Hydro token\n', '    function setHydroContractAddress(address _hydroTokenAddress) public onlyOwner {\n', '        hydroTokenAddress = _hydroTokenAddress;\n', '    }\n', '\n', '    // Allows the Hydro API to set a minimum hydro balance required to register unofficially\n', '    function setHydroStakingMinimum(uint newMinimum) public onlyOwner {\n', '        hydroStakingMinimum = newMinimum;\n', '    }\n', '\n', '    // Indicates whether a given user name has been claimed\n', '    function userNameTaken(string userName) public view returns (bool taken) {\n', '        bytes32 userNameHash = keccak256(userName);\n', '        return userDirectory[userNameHash]._initialized;\n', '    }\n', '\n', '    // Indicates whether a given application name has been claimed for official and unofficial applications\n', '    function applicationNameTaken(string applicationName)\n', '        public\n', '        view\n', '        returns (bool officialTaken, bool unofficialTaken)\n', '    {\n', '        bytes32 applicationNameHash = keccak256(applicationName);\n', '        return (\n', '            officialApplicationDirectory[applicationNameHash]._initialized,\n', '            unofficialApplicationDirectory[applicationNameHash]._initialized\n', '        );\n', '    }\n', '\n', '    // Returns user details by user name\n', '    function getUserByName(string userName) public view returns (address userAddress, bool official) {\n', '        bytes32 userNameHash = keccak256(userName);\n', '        require(userNameHashTaken(userNameHash));\n', '        User storage _user = userDirectory[userNameHash];\n', '\n', '        return (_user.userAddress, _user.official);\n', '    }\n', '\n', '    // Checks whether the provided (v, r, s) signature was created by the private key associated with _address\n', '    function isSigned(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) public pure returns (bool) {\n', '        return ecrecover(messageHash, v, r, s) == _address;\n', '    }\n', '\n', '    // Common internal logic for all user signups\n', '    function _userSignUp(string userName, address userAddress, bool official) internal {\n', '        bytes32 userNameHash = keccak256(userName);\n', '        require(!userNameHashTaken(userNameHash));\n', '        userDirectory[userNameHash] = User(userName, userAddress, official, true);\n', '\n', '        emit UserSignUp(userName, userAddress, official);\n', '    }\n', '\n', '    // Internal check for whether a user name has been taken\n', '    function userNameHashTaken(bytes32 userNameHash) internal view returns (bool) {\n', '        return userDirectory[userNameHash]._initialized;\n', '    }\n', '\n', '    // Internal check for whether an application name has been taken\n', '    function applicationNameHashTaken(bytes32 applicationNameHash, bool official) internal view returns (bool) {\n', '        if (official) {\n', '            return officialApplicationDirectory[applicationNameHash]._initialized;\n', '        } else {\n', '            return unofficialApplicationDirectory[applicationNameHash]._initialized;\n', '        }\n', '    }\n', '}']
