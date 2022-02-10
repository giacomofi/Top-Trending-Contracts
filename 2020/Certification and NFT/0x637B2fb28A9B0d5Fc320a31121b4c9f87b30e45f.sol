['pragma solidity ^0.5.17;\n', '\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract MatrixErc20 {\n', '    using SafeMath for uint;\n', '    address public ownerWallet;\n', '\n', '    struct UserStruct {\n', '        bool isExist;\n', '        uint id;\n', '        mapping (address => uint256) tokenRewards;\n', '        mapping (address => uint) referrerID; //Token address to Referrer ID\n', '        mapping (address => address[]) referral; //Token address to list of addresses\n', '        mapping(address => mapping(uint => uint)) levelExpired; //Token address to level number to expiration date\n', '    }\n', '\n', '    uint REFERRER_1_LEVEL_LIMIT = 5;\n', '    uint PERIOD_LENGTH = 180 days;\n', '    uint ADMIN_FEE_PERCENTAGE = 10;\n', '    mapping(address => mapping(uint => uint)) public LEVEL_PRICE; //Token address to level number to price\n', '    mapping (address => UserStruct) public users;\n', '    mapping (uint => address) public userList;\n', '    uint public currUserID = 0;\n', '    \n', '    mapping (address => bool) public tokens;\n', '    \n', '    mapping (address => uint256) public ownerFees;\n', '\n', '    event regLevelEvent(address indexed _user, address indexed _referrer, uint _time, address _token);\n', '    event buyLevelEvent(address indexed _user, uint _level, uint _time, address _token);\n', '    event prolongateLevelEvent(address indexed _user, uint _level, uint _time, address _token);\n', '    event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, address _token);\n', '    event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, address _token);\n', '    \n', '    function setPeriodLength(uint _periodLength) public onlyOwner {\n', '        PERIOD_LENGTH = _periodLength;\n', '    }\n', '\n', '    function setAdminFeePercentage(uint _adminFeePercentage) public onlyOwner {\n', '        require (_adminFeePercentage >= 0 && _adminFeePercentage <= 100, "Fee must be between 0 and 100");\n', '        \n', '        ADMIN_FEE_PERCENTAGE = _adminFeePercentage;\n', '    }\n', '    \n', '    function toggleToken(address _token, bool _enabled) public onlyOwner {\n', '        tokens[_token] = _enabled;\n', '        \n', '        if (_enabled) {\n', '            for(uint i = 1; i <= 10; i++) {\n', '                users[ownerWallet].levelExpired[_token][i] = 55555555555;\n', '            }\n', '            \n', '            users[ownerWallet].referrerID[_token] = 0;\n', '        }\n', '    }\n', '    \n', '    function setTokenPriceAtLevel(address _token, uint _level, uint _price) public onlyOwner {\n', '        require(_level > 0 && _level <= 10, "Invalid level");\n', '\n', '        LEVEL_PRICE[_token][_level] = _price;\n', '    }\n', '    \n', '    function setTokenPrice(address _token, uint _price1, uint _price2, uint _price3, uint _price4, uint _price5, uint _price6, uint _price7, uint _price8, uint _price9, uint _price10) public onlyOwner {\n', '        LEVEL_PRICE[_token][1] = _price1;\n', '        LEVEL_PRICE[_token][2] = _price2;\n', '        LEVEL_PRICE[_token][3] = _price3;\n', '        LEVEL_PRICE[_token][4] = _price4;\n', '        LEVEL_PRICE[_token][5] = _price5;\n', '        LEVEL_PRICE[_token][6] = _price6;\n', '        LEVEL_PRICE[_token][7] = _price7;\n', '        LEVEL_PRICE[_token][8] = _price8;\n', '        LEVEL_PRICE[_token][9] = _price9;\n', '        LEVEL_PRICE[_token][10] = _price10;\n', '        \n', '        if (!tokens[_token]) {\n', '            toggleToken(_token, true);\n', '        }\n', '    }\n', '\n', '    constructor() public {\n', '        ownerWallet = msg.sender;\n', '\n', '        UserStruct memory userStruct;\n', '        currUserID++;\n', '        \n', '        userStruct = UserStruct({\n', '            isExist: true,\n', '            id: currUserID\n', '        });\n', '        users[ownerWallet] = userStruct;\n', '        userList[currUserID] = ownerWallet;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', "        require(msg.sender == ownerWallet, 'caller must be the owner');\n", '        _;\n', '    }\n', '    \n', '    //Use this before going live to avoid issues\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', "        require(newOwner != address(0), 'new owner is the zero address');\n", "        require(!users[newOwner].isExist, 'new owner needs to be a new address');\n", '        \n', '        UserStruct memory userStruct = UserStruct({\n', '            isExist: true,\n', '            id: 1\n', '        });\n', '        \n', '        users[newOwner] = userStruct;\n', '        userList[1] = newOwner;\n', '\n', '        delete users[ownerWallet];\n', '        ownerWallet = newOwner;\n', '    }\n', '\n', '    function regUser(address _token, uint _referrerID) public payable {\n', '        require(tokens[_token], "Token is not enabled");\n', "        require(!users[msg.sender].isExist, 'User exist');\n", "        require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');\n", '        \n', '        IERC20 token = IERC20(_token);\n', '        require(token.transferFrom(msg.sender, address(this), LEVEL_PRICE[_token][1]), "Couldn\'t take the tokens from the sender");\n', '\n', '        if(users[userList[_referrerID]].referral[_token].length >= REFERRER_1_LEVEL_LIMIT) _referrerID = users[findFreeReferrer(_token, userList[_referrerID])].id;\n', '\n', '        UserStruct memory userStruct;\n', '        currUserID++;\n', '\n', '        userStruct = UserStruct({\n', '            isExist: true,\n', '            id: currUserID\n', '        });\n', '        \n', '        users[msg.sender] = userStruct;\n', '        users[msg.sender].referrerID[_token] = _referrerID;\n', '        userList[currUserID] = msg.sender;\n', '\n', '        users[msg.sender].levelExpired[_token][1] = now + PERIOD_LENGTH;\n', '\n', '        users[userList[_referrerID]].referral[_token].push(msg.sender);\n', '\n', '        payForLevel(_token, 1, msg.sender);\n', '\n', '        emit regLevelEvent(msg.sender, userList[_referrerID], now, _token);\n', '    }\n', '\n', '    function buyLevel(address _token, uint _level) public payable {\n', "        require(users[msg.sender].isExist, 'User not exist'); \n", "        require(_level > 0 && _level <= 10, 'Incorrect level');\n", '        require(tokens[_token], "Token is not enabled");\n', '        \n', '        IERC20 token = IERC20(_token);\n', '        require(token.transferFrom(msg.sender, address(this), LEVEL_PRICE[_token][_level]), "Couldn\'t take the tokens from the sender");\n', '\n', '        if(_level == 1) {\n', '            users[msg.sender].levelExpired[_token][1] += PERIOD_LENGTH;\n', '        }\n', '        else {\n', "            for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpired[_token][l] >= now, 'Buy the previous level');\n", '\n', '            if(users[msg.sender].levelExpired[_token][_level] == 0) users[msg.sender].levelExpired[_token][_level] = now + PERIOD_LENGTH;\n', '            else users[msg.sender].levelExpired[_token][_level] += PERIOD_LENGTH;\n', '        }\n', '\n', '        payForLevel(_token, _level, msg.sender);\n', '\n', '        emit buyLevelEvent(msg.sender, _level, now, _token);\n', '    }\n', '    \n', '    function getRefererInTree(address _token, uint _level, address _user) internal view returns(address) {\n', '        address referer;\n', '        address referer1;\n', '        address referer2;\n', '        address referer3;\n', '        address referer4;\n', '\n', '        if(_level == 1 || _level == 6) {\n', '            referer = userList[users[_user].referrerID[_token]];\n', '        }\n', '        else if(_level == 2 || _level == 7) {\n', '            referer1 = userList[users[_user].referrerID[_token]];\n', '            referer = userList[users[referer1].referrerID[_token]];\n', '        }\n', '        else if(_level == 3 || _level == 8) {\n', '            referer1 = userList[users[_user].referrerID[_token]];\n', '            referer2 = userList[users[referer1].referrerID[_token]];\n', '            referer = userList[users[referer2].referrerID[_token]];\n', '        }\n', '        else if(_level == 4 || _level == 9) {\n', '            referer1 = userList[users[_user].referrerID[_token]];\n', '            referer2 = userList[users[referer1].referrerID[_token]];\n', '            referer3 = userList[users[referer2].referrerID[_token]];\n', '            referer = userList[users[referer3].referrerID[_token]];\n', '        }\n', '        else if(_level == 5 || _level == 10) {\n', '            referer1 = userList[users[_user].referrerID[_token]];\n', '            referer2 = userList[users[referer1].referrerID[_token]];\n', '            referer3 = userList[users[referer2].referrerID[_token]];\n', '            referer4 = userList[users[referer3].referrerID[_token]];\n', '            referer = userList[users[referer4].referrerID[_token]];\n', '        }\n', '\n', '        if(!users[referer].isExist) referer = userList[1];\n', '        \n', '        return referer;\n', '    }\n', '    \n', '    function payForLevel(address _token, uint _level, address _user) internal {\n', '        address referer = getRefererInTree(_token, _level, _user);\n', '\n', '        if(users[referer].levelExpired[_token][_level] >= now) {\n', '            uint levelPrice = LEVEL_PRICE[_token][_level];\n', '            uint payToOwner = levelPrice.mul(ADMIN_FEE_PERCENTAGE).div(100);\n', '            uint payToReferrer = levelPrice.sub(payToOwner);\n', '            users[address(uint160(referer))].tokenRewards[_token] = users[address(uint160(referer))].tokenRewards[_token].add(payToReferrer);\n', '            ownerFees[_token] = ownerFees[_token].add(payToOwner);\n', '\n', '            emit getMoneyForLevelEvent(referer, msg.sender, _level, _token);\n', '        }\n', '        else {\n', '            emit lostMoneyForLevelEvent(referer, msg.sender, _level, now, _token);\n', '\n', '            payForLevel(_token, _level, referer);\n', '        }\n', '    }\n', '\n', '    function findFreeReferrer(address _token, address _user) public view returns(address) {\n', '        if(users[_user].referral[_token].length < REFERRER_1_LEVEL_LIMIT) return _user;\n', '\n', '        address[] memory referrals = new address[](315);\n', '        referrals[0] = users[_user].referral[_token][0];\n', '        referrals[1] = users[_user].referral[_token][1];\n', '        referrals[2] = users[_user].referral[_token][2];\n', '        referrals[3] = users[_user].referral[_token][3];\n', '        referrals[4] = users[_user].referral[_token][4];\n', '\n', '        address freeReferrer;\n', '        bool noFreeReferrer = true;\n', '\n', '        for(uint i = 0; i < 126; i++) {\n', '            if(users[referrals[i]].referral[_token].length == REFERRER_1_LEVEL_LIMIT) {\n', '                if(i < 155) {\n', '                    referrals[(i+1)*2] = users[referrals[i]].referral[_token][0];\n', '                    referrals[(i+1)*2+1] = users[referrals[i]].referral[_token][2];\n', '                    referrals[(i+1)*2+2] = users[referrals[i]].referral[_token][3];\n', '                    referrals[(i+1)*2+3] = users[referrals[i]].referral[_token][4];\n', '                    referrals[(i+1)*2+4] = users[referrals[i]].referral[_token][5];\n', '                }\n', '            }\n', '            else {\n', '                noFreeReferrer = false;\n', '                freeReferrer = referrals[i];\n', '                break;\n', '            }\n', '        }\n', '\n', "        require(!noFreeReferrer, 'No Free Referrer');\n", '\n', '        return freeReferrer;\n', '    }\n', '    \n', '    function withdraw(address _token) public {\n', '        uint256 total = users[msg.sender].tokenRewards[_token];\n', '        require(total > 0, "Nothing to withdraw");\n', '        users[msg.sender].tokenRewards[_token] = 0;\n', '        IERC20 token = IERC20(_token);\n', '        require(token.transfer(msg.sender, total), "Couldn\'t send the tokens");\n', '    }\n', '    \n', '    function _withdrawFees(address _token) public onlyOwner {\n', '        uint256 total = ownerFees[_token];\n', '        require(total > 0, "Nothing to withdraw");\n', '        ownerFees[_token] = 0;\n', '        IERC20 token = IERC20(_token);\n', '        require(token.transfer(msg.sender, total), "Couldn\'t send the tokens");\n', '    }\n', '\n', '    function viewUserReferral(address _token, address _user) public view returns(address[] memory) {\n', '        return users[_user].referral[_token];\n', '    }\n', '\n', '    function viewUserReferrer(address _token, address _user) public view returns(uint256) {\n', '        return users[_user].referrerID[_token];\n', '    }\n', '\n', '    function viewUserLevelExpired(address _token, address _user, uint _level) public view returns(uint) {\n', '        return users[_user].levelExpired[_token][_level];\n', '    }\n', '\n', '    function viewUserIsExist(address _user) public view returns(bool) {\n', '        return users[_user].isExist;\n', '    }\n', '\n', '    function viewUserRewards(address _user, address _token) public view returns(uint256) {\n', '        return users[_user].tokenRewards[_token];\n', '    }\n', '\n', '    function bytesToAddress(bytes memory bys) private pure returns (address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '\n', '    function _close(address payable _to) public onlyOwner { \n', '        selfdestruct(_to);  \n', '    }\n', '}']