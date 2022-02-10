['pragma solidity ^0.5.2;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract EtherStake is Ownable {\n', ' /**\n', ' * EtherStake\n', ' * www.etherstake.me\n', ' * Copyright 2019\n', ' * admin@etherpornstars.com\n', ' */\n', '    \n', '  using SafeMath for uint;\n', '  // Address set to win pot when time runs out\n', '  address payable public  leadAddress;\n', '    // Manage your dividends without MetaMask! Send 0.01 ETH to these directly\n', '  address public reinvestmentContractAddress;\n', '  address public withdrawalContractAddress;\n', '  // Multiplies your stake purchases, starts at 110% and goes down 0.1% a day down to 100% - get in early!\n', '  uint public stakeMultiplier;\n', '  uint public totalStake;\n', '  uint public day;\n', '  uint public roundId;\n', '  uint public roundEndTime;\n', '  uint public startOfNewDay;\n', '  uint public timeInADay;\n', '  uint public timeInAWeek;\n', '  // Optional message shown on the site when your address is leading\n', '  mapping(address => string) public playerMessage;\n', '  mapping(address => string) public playerName;\n', '  // Boundaries for messages\n', '  uint8 constant playerMessageMinLength = 1;\n', '  uint8 constant playerMessageMaxLength = 64;\n', '  mapping (uint => uint) internal seed; //save seed from rounds\n', '  mapping (uint => uint) internal roundIdToDays;\n', '  mapping (address => uint) public spentDivs;\n', '  // Main data structure that tracks all players dividends for current and previous rounds\n', '  mapping(uint => mapping(uint => divKeeper)) public playerDivsInADay;\n', '  // Emitted when user withdraws dividends or wins jackpot\n', '  event CashedOut(address _player, uint _amount);\n', '  event InvestReceipt(\n', '    address _player,\n', '    uint _stakeBought);\n', '    \n', '    struct divKeeper {\n', '      mapping(address => uint) playerStakeAtDay;\n', '      uint totalStakeAtDay;\n', '      uint revenueAtDay;\n', '  } \n', '\n', '    constructor() public {\n', '        roundId = 1;\n', '        timeInADay = 86400; // 86400 seconds in a day\n', '        timeInAWeek = 604800; // 604800 seconds in a week\n', '        roundEndTime = now + timeInAWeek; // round 1 end time 604800 seconds=7 days\n', '        startOfNewDay = now + timeInADay;\n', '        stakeMultiplier = 1100;\n', '        totalStake = 1000000000; \n', '    }\n', '\n', '\n', '\n', '    function() external payable {\n', '        require(msg.value >= 10000000000000000 && msg.value < 1000000000000000000000, "0.01 ETH minimum."); // Minimum stake buy is 0.01 ETH, max 1000\n', '\n', '        if(now > roundEndTime){ // Check if round is over, then start new round. \n', '            startNewRound();\n', '        }\n', '\n', '        uint stakeBought = msg.value.mul(stakeMultiplier);\n', '        stakeBought = stakeBought.div(1000);\n', '        playerDivsInADay[roundId][day].playerStakeAtDay[msg.sender] += stakeBought;\n', '        leadAddress = msg.sender;\n', '        totalStake += stakeBought;\n', '        addTime(stakeBought); // Add time based on amount bought\n', '        emit InvestReceipt(msg.sender, stakeBought);\n', '    }\n', '\n', '    // Referrals only work with this function\n', '    function buyStakeWithEth(address _referrer) public payable {\n', '        require(msg.value >= 10000000000000000, "0.01 ETH minimum.");\n', '        if(_referrer != address(0)){\n', '                uint _referralBonus = msg.value.div(50); // 2% referral\n', '                if(_referrer == msg.sender) {\n', '                    _referrer = 0x93D43eeFcFbE8F9e479E172ee5d92DdDd2600E3b; // if user tries to refer himself\n', '                }\n', '                playerDivsInADay[roundId][day].playerStakeAtDay[_referrer] += _referralBonus;\n', '        }\n', '        if(now > roundEndTime){\n', '            startNewRound();\n', '        }\n', '\n', '        uint stakeBought = msg.value.mul(stakeMultiplier);\n', '        stakeBought = stakeBought.div(1000);\n', '        playerDivsInADay[roundId][day].playerStakeAtDay[msg.sender] += stakeBought;\n', '        leadAddress = msg.sender;\n', '        totalStake += stakeBought;\n', '        addTime(stakeBought);\n', '        emit InvestReceipt(msg.sender, stakeBought);\n', '    }\n', '    \n', '\n', '    // Message stored forever, but only displayed on the site when your address is leading\n', '    function addMessage(string memory _message) public {\n', '        bytes memory _messageBytes = bytes(_message);\n', '        require(_messageBytes.length >= playerMessageMinLength, "Too short");\n', '        require(_messageBytes.length <= playerMessageMaxLength, "Too long");\n', '        playerMessage[msg.sender] = _message;\n', '    }\n', '    function getMessage(address _playerAddress)\n', '    external\n', '    view\n', '    returns (\n', '      string memory playerMessage_\n', '  ) {\n', '      playerMessage_ = playerMessage[_playerAddress];\n', '  }\n', '      // Name stored forever, but only displayed on the site when your address is leading\n', '    function addName(string memory _name) public {\n', '        bytes memory _messageBytes = bytes(_name);\n', '        require(_messageBytes.length >= playerMessageMinLength, "Too short");\n', '        require(_messageBytes.length <= playerMessageMaxLength, "Too long");\n', '        playerName[msg.sender] = _name;\n', '    }\n', '  \n', '    function getName(address _playerAddress)\n', '    external\n', '    view\n', '    returns (\n', '      string memory playerName_\n', '  ) {\n', '      playerName_ = playerName[_playerAddress];\n', '  }\n', '   \n', '    \n', '    function getPlayerCurrentRoundDivs(address _playerAddress) public view returns(uint playerTotalDivs) {\n', '        uint _playerTotalDivs;\n', '        uint _playerRollingStake;\n', '        for(uint c = 0 ; c < day; c++) { //iterate through all days of current round \n', '            uint _playerStakeAtDay = playerDivsInADay[roundId][c].playerStakeAtDay[_playerAddress];\n', '            if(_playerStakeAtDay == 0 && _playerRollingStake == 0){\n', '                    continue; //if player has no stake then continue out to save gas\n', '                }\n', '            _playerRollingStake += _playerStakeAtDay;\n', '            uint _revenueAtDay = playerDivsInADay[roundId][c].revenueAtDay;\n', '            uint _totalStakeAtDay = playerDivsInADay[roundId][c].totalStakeAtDay;\n', '            uint _playerShareAtDay = _playerRollingStake.mul(_revenueAtDay)/_totalStakeAtDay;\n', '            _playerTotalDivs += _playerShareAtDay;\n', '        }\n', '        return _playerTotalDivs.div(2); // Divide by 2, 50% goes to players as dividends, 50% goes to the jackpot.\n', '    }\n', '    \n', '    function getPlayerPreviousRoundDivs(address _playerAddress) public view returns(uint playerPreviousRoundDivs) {\n', '        uint _playerPreviousRoundDivs;\n', '        for(uint r = 1 ; r < roundId; r++) { // Iterate through all previous rounds \n', '            uint _playerRollingStake;\n', '            uint _lastDay = roundIdToDays[r];\n', '            for(uint p = 0 ; p < _lastDay; p++) { //iterate through all days of previous round \n', '                uint _playerStakeAtDay = playerDivsInADay[r][p].playerStakeAtDay[_playerAddress];\n', '                if(_playerStakeAtDay == 0 && _playerRollingStake == 0){\n', '                        continue; // If player has no stake then continue to next day to save gas\n', '                    }\n', '                _playerRollingStake += _playerStakeAtDay;\n', '                uint _revenueAtDay = playerDivsInADay[r][p].revenueAtDay;\n', '                uint _totalStakeAtDay = playerDivsInADay[r][p].totalStakeAtDay;\n', '                uint _playerShareAtDay = _playerRollingStake.mul(_revenueAtDay)/_totalStakeAtDay;\n', '                _playerPreviousRoundDivs += _playerShareAtDay;\n', '            }\n', '        }\n', '        return _playerPreviousRoundDivs.div(2); // Divide by 2, 50% goes to players as dividends, 50% goes to the jackpot.\n', '    }\n', '    \n', '    function getPlayerTotalDivs(address _playerAddress) public view returns(uint PlayerTotalDivs) {\n', '        uint _playerTotalDivs;\n', '        _playerTotalDivs += getPlayerPreviousRoundDivs(_playerAddress);\n', '        _playerTotalDivs += getPlayerCurrentRoundDivs(_playerAddress);\n', '        \n', '        return _playerTotalDivs;\n', '    }\n', '    \n', '    function getPlayerCurrentStake(address _playerAddress) public view returns(uint playerCurrentStake) {\n', '        uint _playerRollingStake;\n', '        for(uint c = 0 ; c <= day; c++) { //iterate through all days of current round \n', '            uint _playerStakeAtDay = playerDivsInADay[roundId][c].playerStakeAtDay[_playerAddress];\n', '            if(_playerStakeAtDay == 0 && _playerRollingStake == 0){\n', '                    continue; //if player has no stake then continue out to save gas\n', '                }\n', '            _playerRollingStake += _playerStakeAtDay;\n', '        }\n', '        return _playerRollingStake;\n', '    }\n', '    \n', '\n', '    // Buy a stake using your earned dividends from past or current round\n', '    function reinvestDivs(uint _divs) external{\n', '        require(_divs >= 10000000000000000, "You need at least 0.01 ETH in dividends.");\n', '        uint _senderDivs = getPlayerTotalDivs(msg.sender);\n', '        spentDivs[msg.sender] += _divs;\n', '        uint _spentDivs = spentDivs[msg.sender];\n', '        uint _availableDivs = _senderDivs.sub(_spentDivs);\n', '        require(_availableDivs >= 0);\n', '        if(now > roundEndTime){\n', '            startNewRound();\n', '        }\n', '        playerDivsInADay[roundId][day].playerStakeAtDay[msg.sender] += _divs;\n', '        leadAddress = msg.sender;\n', '        totalStake += _divs;\n', '        addTime(_divs);\n', '        emit InvestReceipt(msg.sender, _divs);\n', '    }\n', '    // Turn your earned dividends from past or current rounds into Ether\n', '    function withdrawDivs(uint _divs) external{\n', '        require(_divs >= 10000000000000000, "You need at least 0.01 ETH in dividends.");\n', '        uint _senderDivs = getPlayerTotalDivs(msg.sender);\n', '        spentDivs[msg.sender] += _divs;\n', '        uint _spentDivs = spentDivs[msg.sender];\n', '        uint _availableDivs = _senderDivs.sub(_spentDivs);\n', '        require(_availableDivs >= 0);\n', '        msg.sender.transfer(_divs);\n', '        emit CashedOut(msg.sender, _divs);\n', '    }\n', '    // Reinvests all of a players dividends using contract, for people without MetaMask\n', '    function reinvestDivsWithContract(address payable _reinvestor) external{ \n', '        require(msg.sender == reinvestmentContractAddress);\n', '        uint _senderDivs = getPlayerTotalDivs(_reinvestor);\n', '        uint _spentDivs = spentDivs[_reinvestor];\n', '        uint _availableDivs = _senderDivs.sub(_spentDivs);\n', '        spentDivs[_reinvestor] += _senderDivs;\n', '        require(_availableDivs >= 10000000000000000, "You need at least 0.01 ETH in dividends.");\n', '        if(now > roundEndTime){\n', '            startNewRound();\n', '        }\n', '        playerDivsInADay[roundId][day].playerStakeAtDay[_reinvestor] += _availableDivs;\n', '        leadAddress = _reinvestor;\n', '        totalStake += _availableDivs;\n', '        addTime(_availableDivs);\n', '        emit InvestReceipt(msg.sender, _availableDivs);\n', '    }\n', '    // Withdraws all of a players dividends using contract, for people without MetaMask\n', '    function withdrawDivsWithContract(address payable _withdrawer) external{ \n', '        require(msg.sender == withdrawalContractAddress);\n', '        uint _senderDivs = getPlayerTotalDivs(_withdrawer);\n', '        uint _spentDivs = spentDivs[_withdrawer];\n', '        uint _availableDivs = _senderDivs.sub(_spentDivs);\n', '        spentDivs[_withdrawer] += _availableDivs;\n', '        require(_availableDivs >= 0);\n', '        _withdrawer.transfer(_availableDivs);\n', '        emit CashedOut(_withdrawer, _availableDivs);\n', '    }\n', '    \n', '    // Time functions\n', '    function addTime(uint _stakeBought) private {\n', '        uint _timeAdd = _stakeBought/1000000000000; //1000000000000 0.01 ETH adds 2.77 hours\n', '        if(_timeAdd < timeInADay){\n', '            roundEndTime += _timeAdd;\n', '        }else{\n', '        roundEndTime += timeInADay; //24 hour cap\n', '        }\n', '            \n', '        if(now > startOfNewDay) { //check if 24 hours has passed\n', '            startNewDay();\n', '        }\n', '    }\n', '    \n', '    function startNewDay() private {\n', '        playerDivsInADay[roundId][day].totalStakeAtDay = totalStake;\n', '        playerDivsInADay[roundId][day].revenueAtDay = totalStake - playerDivsInADay[roundId][day-1].totalStakeAtDay; //div revenue today = pot today - pot yesterday\n', '        if(stakeMultiplier > 1000) {\n', '            stakeMultiplier -= 1;\n', '        }\n', '        startOfNewDay = now + timeInADay;\n', '        ++day;\n', '    }\n', '\n', '    function startNewRound() private { \n', '        playerDivsInADay[roundId][day].totalStakeAtDay = totalStake; //commit last changes to ending round\n', '        playerDivsInADay[roundId][day].revenueAtDay = totalStake - playerDivsInADay[roundId][day-1].totalStakeAtDay; //div revenue today = pot today - pot yesterday\n', '        roundIdToDays[roundId] = day; //save last day of ending round\n', '        jackpot();\n', '        resetRound();\n', '    }\n', '    function jackpot() private {\n', '        uint winnerShare = playerDivsInADay[roundId][day].totalStakeAtDay.div(2) + seed[roundId]; //add last seed to pot\n', '        seed[roundId+1] = totalStake.div(10); //10% of pot to seed next round\n', '        winnerShare -= seed[roundId+1];\n', '        leadAddress.transfer(winnerShare);\n', '        emit CashedOut(leadAddress, winnerShare);\n', '    }\n', '    function resetRound() private {\n', '        roundId += 1;\n', '        roundEndTime = now + timeInAWeek;  //add 1 week time to start next round\n', '        startOfNewDay = now; // save day start time, multiplier decreases 0.1%/day\n', '        day = 0;\n', '        stakeMultiplier = 1100;\n', '        totalStake = 10000000;\n', '    }\n', '\n', '    function returnTimeLeft()\n', '     public view\n', '     returns(uint256) {\n', '     return(roundEndTime.sub(now));\n', '     }\n', '     \n', '    function returnDayTimeLeft()\n', '     public view\n', '     returns(uint256) {\n', '     return(startOfNewDay.sub(now));\n', '     }\n', '     \n', '    function returnSeedAtRound(uint _roundId)\n', '     public view\n', '     returns(uint256) {\n', '     return(seed[_roundId]);\n', '     }\n', '    function returnjackpot()\n', '     public view \n', '     returns(uint256){\n', '        uint winnerShare = totalStake/2 + seed[roundId]; //add last seed to pot\n', '        uint nextseed = totalStake/10; //10% of pot to seed next round\n', '        winnerShare -= nextseed;\n', '        return winnerShare;\n', '    }\n', '    function returnEarningsAtDay(uint256 _roundId, uint256 _day, address _playerAddress)\n', '     public view \n', '     returns(uint256){\n', '        uint earnings = playerDivsInADay[_roundId][_day].playerStakeAtDay[_playerAddress];\n', '        return earnings;\n', '    }\n', '      function setWithdrawalAndReinvestmentContracts(address _withdrawalContractAddress, address _reinvestmentContractAddress) external onlyOwner {\n', '    withdrawalContractAddress = _withdrawalContractAddress;\n', '    reinvestmentContractAddress = _reinvestmentContractAddress;\n', '  }\n', '}\n', '\n', 'contract WithdrawalContract {\n', '    \n', '    address payable public etherStakeAddress;\n', '    address payable public owner;\n', '    \n', '    \n', '    constructor(address payable _etherStakeAddress) public {\n', '        etherStakeAddress = _etherStakeAddress;\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function() external payable{\n', '        require(msg.value >= 10000000000000000, "0.01 ETH Fee");\n', '        EtherStake instanceEtherStake = EtherStake(etherStakeAddress);\n', '        instanceEtherStake.withdrawDivsWithContract(msg.sender);\n', '    }\n', '    \n', '    function collectFees() external {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '}']