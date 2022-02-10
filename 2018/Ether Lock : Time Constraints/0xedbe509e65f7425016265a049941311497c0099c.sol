['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    modifier notOwner() {\n', '        require(msg.sender != owner);\n', '        _;\n', '    }\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Resume();\n', '\n', '    bool public paused = false;\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to resume, returns to normal state\n', '     */\n', '    function resume() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Resume();\n', '    }\n', '}\n', '\n', 'contract LuckyYouTokenInterface {\n', '    function airDrop(address _to, uint256 _value) public returns (bool);\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '}\n', '\n', 'contract LuckyYouContract is Pausable {\n', '    using SafeMath for uint256;\n', '    LuckyYouTokenInterface public luckyYouToken = LuckyYouTokenInterface(0x6D7efEB3DF42e6075fa7Cf04E278d2D69e26a623); //LKY token address\n', '    bool public airDrop = true;// weather airdrop LKY tokens to participants or not,owner can set it to true or false;\n', '\n', '    //set airDrop flag\n', '    function setAirDrop(bool _airDrop) public onlyOwner {\n', '        airDrop = _airDrop;\n', '    }\n', '\n', '    //if airdrop LKY token to participants , this is airdrop rate per round depends on participated times, owner can set it\n', '    uint public baseTokenGetRate = 100;\n', '\n', '    // set token get rate\n', '    function setBaseTokenGetRate(uint _baseTokenGetRate) public onlyOwner {\n', '        baseTokenGetRate = _baseTokenGetRate;\n', '    }\n', '\n', '    //if the number of participants less than  minParticipants,game will not be fired.owner can set it\n', '    uint public minParticipants = 50;\n', '\n', '    function setMinParticipants(uint _minParticipants) public onlyOwner {\n', '        minParticipants = _minParticipants;\n', '    }\n', '\n', '    //base price ,owner can set it\n', '    uint public basePrice = 0.01 ether;\n', '\n', '    function setBasePrice(uint _basePrice) public onlyOwner {\n', '        basePrice = _basePrice;\n', '    }\n', '\n', '    uint[5] public times = [1, 5, 5 * 5, 5 * 5 * 5, 5 * 5 * 5 * 5];//1x=0.01 ether;5x=0.05 ether; 5*5x=0.25 ether; 5*5*5x=1.25 ether; 5*5*5*5x=6.25 ether;\n', '    //at first only enable 1x(0.02ether) ,enable others proper time in future\n', '    bool[5] public timesEnabled = [true, false, false, false, false];\n', '\n', '    uint[5] public currentCounter = [1, 1, 1, 1, 1];\n', '    mapping(address => uint[5]) public participatedCounter;\n', '    mapping(uint8 => address[]) private participants;\n', '    //todo\n', '    mapping(uint8 => uint256) public participantsCount;\n', '    mapping(uint8 => uint256) public fundShareLastRound;\n', '    mapping(uint8 => uint256) public fundCurrentRound;\n', '    mapping(uint8 => uint256) public fundShareRemainLastRound;\n', '    mapping(uint8 => uint256) public fundShareParticipantsTotalTokensLastRound;\n', '    mapping(uint8 => uint256) public fundShareParticipantsTotalTokensCurrentRound;\n', '    mapping(uint8 => bytes32) private participantsHashes;\n', '\n', '    mapping(uint8 => uint8) private lastFiredStep;\n', '    mapping(uint8 => address) public lastWinner;\n', '    mapping(uint8 => address) public lastFiredWinner;\n', '    mapping(uint8 => uint256) public lastWinnerReward;\n', '    mapping(uint8 => uint256) public lastFiredWinnerReward;\n', '    mapping(uint8 => uint256) public lastFiredFund;\n', '    mapping(address => uint256) public whitelist;\n', '    uint256 public notInWhitelistAllow = 1;\n', '\n', '    bytes32  private commonHash = 0x1000;\n', '\n', '    uint256 public randomNumberIncome = 0;\n', '\n', '    event Winner1(address value, uint times, uint counter, uint256 reward);\n', '    event Winner2(address value, uint times, uint counter, uint256 reward);\n', '\n', '\n', '    function setNotInWhitelistAllow(uint _value) public onlyOwner\n', '    {\n', '        notInWhitelistAllow = _value;\n', '    }\n', '\n', '    function setWhitelist(uint _value,address [] _addresses) public onlyOwner\n', '    {\n', '        uint256 count = _addresses.length;\n', '        for (uint256 i = 0; i < count; i++) {\n', '            whitelist[_addresses [i]] = _value;\n', '        }\n', '    }\n', '\n', '    function setTimesEnabled(uint8 _timesIndex, bool _enabled) public onlyOwner\n', '    {\n', '        require(_timesIndex < timesEnabled.length);\n', '        timesEnabled[_timesIndex] = _enabled;\n', '    }\n', '\n', '    function() public payable whenNotPaused {\n', '\n', '        if(whitelist[msg.sender] | notInWhitelistAllow > 0)\n', '        {\n', '            uint8 _times_length = uint8(times.length);\n', '            uint8 _times = _times_length + 1;\n', '            for (uint32 i = 0; i < _times_length; i++)\n', '            {\n', '                if (timesEnabled[i])\n', '                {\n', '                    if (times[i] * basePrice == msg.value) {\n', '                        _times = uint8(i);\n', '                        break;\n', '                    }\n', '                }\n', '            }\n', '            if (_times > _times_length) {\n', '                revert();\n', '            }\n', '            else\n', '            {\n', '                if (participatedCounter[msg.sender][_times] < currentCounter[_times])\n', '                {\n', '                    participatedCounter[msg.sender][_times] = currentCounter[_times];\n', '                    if (airDrop)\n', '                    {\n', '                        uint256 _value = baseTokenGetRate * 10 ** 18 * times[_times];\n', '                        uint256 _plus_value = uint256(keccak256(now, msg.sender)) % _value;\n', '                        luckyYouToken.airDrop(msg.sender, _value + _plus_value);\n', '                    }\n', '                    uint256 senderBalance = luckyYouToken.balanceOf(msg.sender);\n', '                    if (lastFiredStep[_times] > 0)\n', '                    {\n', '                        issueLottery(_times);\n', '                        fundShareParticipantsTotalTokensCurrentRound[_times] += senderBalance;\n', '                        senderBalance = senderBalance.mul(2);\n', '                    } else\n', '                    {\n', '                        fundShareParticipantsTotalTokensCurrentRound[_times] += senderBalance;\n', '                    }\n', '                    if (participantsCount[_times] == participants[_times].length)\n', '                    {\n', '                        participants[_times].length += 1;\n', '                    }\n', '                    participants[_times][participantsCount[_times]++] = msg.sender;\n', '                    participantsHashes[_times] = keccak256(msg.sender, uint256(commonHash));\n', '                    commonHash = keccak256(senderBalance,commonHash);\n', '                    fundCurrentRound[_times] += times[_times] * basePrice;\n', '\n', '                    //share last round fund\n', '                    if (fundShareRemainLastRound[_times] > 0)\n', '                    {\n', '                        uint256 _shareFund = fundShareLastRound[_times].mul(senderBalance).div(fundShareParticipantsTotalTokensLastRound[_times]);\n', '                        if(_shareFund  > 0)\n', '                        {\n', '                            if (_shareFund <= fundShareRemainLastRound[_times]) {\n', '                                fundShareRemainLastRound[_times] -= _shareFund;\n', '                                msg.sender.transfer(_shareFund);\n', '                            } else {\n', '                                uint256 _fundShareRemain = fundShareRemainLastRound[_times];\n', '                                fundShareRemainLastRound[_times] = 0;\n', '                                msg.sender.transfer(_fundShareRemain);\n', '                            }\n', '                        }\n', '                    }\n', '\n', '                    if (participantsCount[_times] > minParticipants)\n', '                    {\n', '                        if (uint256(keccak256(now, msg.sender, commonHash)) % (minParticipants * minParticipants) < minParticipants)\n', '                        {\n', '                            fireLottery(_times);\n', '                        }\n', '\n', '                    }\n', '                } else\n', '                {\n', '                    revert();\n', '                }\n', '            }\n', '        }else{\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function issueLottery(uint8 _times) private {\n', '        uint256 _totalFundRate = lastFiredFund[_times].div(100);\n', '        if (lastFiredStep[_times] == 1) {\n', '            fundShareLastRound[_times] = _totalFundRate.mul(30) + fundShareRemainLastRound[_times];\n', '            if (randomNumberIncome > 0)\n', '            {\n', '                if (_times == (times.length - 1) || timesEnabled[_times + 1] == false)\n', '                {\n', '                    fundShareLastRound[_times] += randomNumberIncome;\n', '                    randomNumberIncome = 0;\n', '                }\n', '            }\n', '            fundShareRemainLastRound[_times] = fundShareLastRound[_times];\n', '            fundShareParticipantsTotalTokensLastRound[_times] = fundShareParticipantsTotalTokensCurrentRound[_times];\n', '            fundShareParticipantsTotalTokensCurrentRound[_times] = 0;\n', '            if(fundShareParticipantsTotalTokensLastRound[_times] == 0)\n', '            {\n', '                fundShareParticipantsTotalTokensLastRound[_times] = 10000 * 10 ** 18;\n', '            }\n', '            lastFiredStep[_times]++;\n', '        } else if (lastFiredStep[_times] == 2) {\n', '            lastWinner[_times].transfer(_totalFundRate.mul(65));\n', '            lastFiredStep[_times]++;\n', '            lastWinnerReward[_times] = _totalFundRate.mul(65);\n', '            emit Winner1(lastWinner[_times], _times, currentCounter[_times] - 1, _totalFundRate.mul(65));\n', '        } else if (lastFiredStep[_times] == 3) {\n', '            if (lastFiredFund[_times] > (_totalFundRate.mul(30) + _totalFundRate.mul(4) + _totalFundRate.mul(65)))\n', '            {\n', '                owner.transfer(lastFiredFund[_times] - _totalFundRate.mul(30) - _totalFundRate.mul(4) - _totalFundRate.mul(65));\n', '            }\n', '            lastFiredStep[_times] = 0;\n', '        }\n', '    }\n', '\n', '    function fireLottery(uint8 _times) private {\n', '        lastFiredFund[_times] = fundCurrentRound[_times];\n', '        fundCurrentRound[_times] = 0;\n', '        lastWinner[_times] = participants[_times][uint256(participantsHashes[_times]) % participantsCount[_times]];\n', '        participantsCount[_times] = 0;\n', '        uint256 winner2Reward = lastFiredFund[_times].div(100).mul(4);\n', '        msg.sender.transfer(winner2Reward);\n', '        lastFiredWinner[_times] = msg.sender;\n', '        lastFiredWinnerReward[_times] = winner2Reward;\n', '        emit Winner2(msg.sender, _times, currentCounter[_times], winner2Reward);\n', '        lastFiredStep[_times] = 1;\n', '        currentCounter[_times]++;\n', '    }\n', '\n', '    function _getRandomNumber(uint _round) view private returns (uint256){\n', '        return uint256(keccak256(\n', '                participantsHashes[0],\n', '                participantsHashes[1],\n', '                participantsHashes[2],\n', '                participantsHashes[3],\n', '                participantsHashes[4],\n', '                msg.sender\n', '            )) % _round;\n', '    }\n', '\n', '    function getRandomNumber(uint _round) public payable returns (uint256){\n', '        uint256 tokenBalance = luckyYouToken.balanceOf(msg.sender);\n', '        if (tokenBalance >= 100000 * 10 ** 18)\n', '        {\n', '            return _getRandomNumber(_round);\n', '        } else if (msg.value >= basePrice) {\n', '            randomNumberIncome += msg.value;\n', '            return _getRandomNumber(_round);\n', '        } else {\n', '            revert();\n', '            return 0;\n', '        }\n', '    }\n', '    //in case some bugs\n', '    function kill() public {//for test\n', '        if (msg.sender == owner)\n', '        {\n', '            selfdestruct(owner);\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    modifier notOwner() {\n', '        require(msg.sender != owner);\n', '        _;\n', '    }\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Resume();\n', '\n', '    bool public paused = false;\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to resume, returns to normal state\n', '     */\n', '    function resume() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Resume();\n', '    }\n', '}\n', '\n', 'contract LuckyYouTokenInterface {\n', '    function airDrop(address _to, uint256 _value) public returns (bool);\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '}\n', '\n', 'contract LuckyYouContract is Pausable {\n', '    using SafeMath for uint256;\n', '    LuckyYouTokenInterface public luckyYouToken = LuckyYouTokenInterface(0x6D7efEB3DF42e6075fa7Cf04E278d2D69e26a623); //LKY token address\n', '    bool public airDrop = true;// weather airdrop LKY tokens to participants or not,owner can set it to true or false;\n', '\n', '    //set airDrop flag\n', '    function setAirDrop(bool _airDrop) public onlyOwner {\n', '        airDrop = _airDrop;\n', '    }\n', '\n', '    //if airdrop LKY token to participants , this is airdrop rate per round depends on participated times, owner can set it\n', '    uint public baseTokenGetRate = 100;\n', '\n', '    // set token get rate\n', '    function setBaseTokenGetRate(uint _baseTokenGetRate) public onlyOwner {\n', '        baseTokenGetRate = _baseTokenGetRate;\n', '    }\n', '\n', '    //if the number of participants less than  minParticipants,game will not be fired.owner can set it\n', '    uint public minParticipants = 50;\n', '\n', '    function setMinParticipants(uint _minParticipants) public onlyOwner {\n', '        minParticipants = _minParticipants;\n', '    }\n', '\n', '    //base price ,owner can set it\n', '    uint public basePrice = 0.01 ether;\n', '\n', '    function setBasePrice(uint _basePrice) public onlyOwner {\n', '        basePrice = _basePrice;\n', '    }\n', '\n', '    uint[5] public times = [1, 5, 5 * 5, 5 * 5 * 5, 5 * 5 * 5 * 5];//1x=0.01 ether;5x=0.05 ether; 5*5x=0.25 ether; 5*5*5x=1.25 ether; 5*5*5*5x=6.25 ether;\n', '    //at first only enable 1x(0.02ether) ,enable others proper time in future\n', '    bool[5] public timesEnabled = [true, false, false, false, false];\n', '\n', '    uint[5] public currentCounter = [1, 1, 1, 1, 1];\n', '    mapping(address => uint[5]) public participatedCounter;\n', '    mapping(uint8 => address[]) private participants;\n', '    //todo\n', '    mapping(uint8 => uint256) public participantsCount;\n', '    mapping(uint8 => uint256) public fundShareLastRound;\n', '    mapping(uint8 => uint256) public fundCurrentRound;\n', '    mapping(uint8 => uint256) public fundShareRemainLastRound;\n', '    mapping(uint8 => uint256) public fundShareParticipantsTotalTokensLastRound;\n', '    mapping(uint8 => uint256) public fundShareParticipantsTotalTokensCurrentRound;\n', '    mapping(uint8 => bytes32) private participantsHashes;\n', '\n', '    mapping(uint8 => uint8) private lastFiredStep;\n', '    mapping(uint8 => address) public lastWinner;\n', '    mapping(uint8 => address) public lastFiredWinner;\n', '    mapping(uint8 => uint256) public lastWinnerReward;\n', '    mapping(uint8 => uint256) public lastFiredWinnerReward;\n', '    mapping(uint8 => uint256) public lastFiredFund;\n', '    mapping(address => uint256) public whitelist;\n', '    uint256 public notInWhitelistAllow = 1;\n', '\n', '    bytes32  private commonHash = 0x1000;\n', '\n', '    uint256 public randomNumberIncome = 0;\n', '\n', '    event Winner1(address value, uint times, uint counter, uint256 reward);\n', '    event Winner2(address value, uint times, uint counter, uint256 reward);\n', '\n', '\n', '    function setNotInWhitelistAllow(uint _value) public onlyOwner\n', '    {\n', '        notInWhitelistAllow = _value;\n', '    }\n', '\n', '    function setWhitelist(uint _value,address [] _addresses) public onlyOwner\n', '    {\n', '        uint256 count = _addresses.length;\n', '        for (uint256 i = 0; i < count; i++) {\n', '            whitelist[_addresses [i]] = _value;\n', '        }\n', '    }\n', '\n', '    function setTimesEnabled(uint8 _timesIndex, bool _enabled) public onlyOwner\n', '    {\n', '        require(_timesIndex < timesEnabled.length);\n', '        timesEnabled[_timesIndex] = _enabled;\n', '    }\n', '\n', '    function() public payable whenNotPaused {\n', '\n', '        if(whitelist[msg.sender] | notInWhitelistAllow > 0)\n', '        {\n', '            uint8 _times_length = uint8(times.length);\n', '            uint8 _times = _times_length + 1;\n', '            for (uint32 i = 0; i < _times_length; i++)\n', '            {\n', '                if (timesEnabled[i])\n', '                {\n', '                    if (times[i] * basePrice == msg.value) {\n', '                        _times = uint8(i);\n', '                        break;\n', '                    }\n', '                }\n', '            }\n', '            if (_times > _times_length) {\n', '                revert();\n', '            }\n', '            else\n', '            {\n', '                if (participatedCounter[msg.sender][_times] < currentCounter[_times])\n', '                {\n', '                    participatedCounter[msg.sender][_times] = currentCounter[_times];\n', '                    if (airDrop)\n', '                    {\n', '                        uint256 _value = baseTokenGetRate * 10 ** 18 * times[_times];\n', '                        uint256 _plus_value = uint256(keccak256(now, msg.sender)) % _value;\n', '                        luckyYouToken.airDrop(msg.sender, _value + _plus_value);\n', '                    }\n', '                    uint256 senderBalance = luckyYouToken.balanceOf(msg.sender);\n', '                    if (lastFiredStep[_times] > 0)\n', '                    {\n', '                        issueLottery(_times);\n', '                        fundShareParticipantsTotalTokensCurrentRound[_times] += senderBalance;\n', '                        senderBalance = senderBalance.mul(2);\n', '                    } else\n', '                    {\n', '                        fundShareParticipantsTotalTokensCurrentRound[_times] += senderBalance;\n', '                    }\n', '                    if (participantsCount[_times] == participants[_times].length)\n', '                    {\n', '                        participants[_times].length += 1;\n', '                    }\n', '                    participants[_times][participantsCount[_times]++] = msg.sender;\n', '                    participantsHashes[_times] = keccak256(msg.sender, uint256(commonHash));\n', '                    commonHash = keccak256(senderBalance,commonHash);\n', '                    fundCurrentRound[_times] += times[_times] * basePrice;\n', '\n', '                    //share last round fund\n', '                    if (fundShareRemainLastRound[_times] > 0)\n', '                    {\n', '                        uint256 _shareFund = fundShareLastRound[_times].mul(senderBalance).div(fundShareParticipantsTotalTokensLastRound[_times]);\n', '                        if(_shareFund  > 0)\n', '                        {\n', '                            if (_shareFund <= fundShareRemainLastRound[_times]) {\n', '                                fundShareRemainLastRound[_times] -= _shareFund;\n', '                                msg.sender.transfer(_shareFund);\n', '                            } else {\n', '                                uint256 _fundShareRemain = fundShareRemainLastRound[_times];\n', '                                fundShareRemainLastRound[_times] = 0;\n', '                                msg.sender.transfer(_fundShareRemain);\n', '                            }\n', '                        }\n', '                    }\n', '\n', '                    if (participantsCount[_times] > minParticipants)\n', '                    {\n', '                        if (uint256(keccak256(now, msg.sender, commonHash)) % (minParticipants * minParticipants) < minParticipants)\n', '                        {\n', '                            fireLottery(_times);\n', '                        }\n', '\n', '                    }\n', '                } else\n', '                {\n', '                    revert();\n', '                }\n', '            }\n', '        }else{\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function issueLottery(uint8 _times) private {\n', '        uint256 _totalFundRate = lastFiredFund[_times].div(100);\n', '        if (lastFiredStep[_times] == 1) {\n', '            fundShareLastRound[_times] = _totalFundRate.mul(30) + fundShareRemainLastRound[_times];\n', '            if (randomNumberIncome > 0)\n', '            {\n', '                if (_times == (times.length - 1) || timesEnabled[_times + 1] == false)\n', '                {\n', '                    fundShareLastRound[_times] += randomNumberIncome;\n', '                    randomNumberIncome = 0;\n', '                }\n', '            }\n', '            fundShareRemainLastRound[_times] = fundShareLastRound[_times];\n', '            fundShareParticipantsTotalTokensLastRound[_times] = fundShareParticipantsTotalTokensCurrentRound[_times];\n', '            fundShareParticipantsTotalTokensCurrentRound[_times] = 0;\n', '            if(fundShareParticipantsTotalTokensLastRound[_times] == 0)\n', '            {\n', '                fundShareParticipantsTotalTokensLastRound[_times] = 10000 * 10 ** 18;\n', '            }\n', '            lastFiredStep[_times]++;\n', '        } else if (lastFiredStep[_times] == 2) {\n', '            lastWinner[_times].transfer(_totalFundRate.mul(65));\n', '            lastFiredStep[_times]++;\n', '            lastWinnerReward[_times] = _totalFundRate.mul(65);\n', '            emit Winner1(lastWinner[_times], _times, currentCounter[_times] - 1, _totalFundRate.mul(65));\n', '        } else if (lastFiredStep[_times] == 3) {\n', '            if (lastFiredFund[_times] > (_totalFundRate.mul(30) + _totalFundRate.mul(4) + _totalFundRate.mul(65)))\n', '            {\n', '                owner.transfer(lastFiredFund[_times] - _totalFundRate.mul(30) - _totalFundRate.mul(4) - _totalFundRate.mul(65));\n', '            }\n', '            lastFiredStep[_times] = 0;\n', '        }\n', '    }\n', '\n', '    function fireLottery(uint8 _times) private {\n', '        lastFiredFund[_times] = fundCurrentRound[_times];\n', '        fundCurrentRound[_times] = 0;\n', '        lastWinner[_times] = participants[_times][uint256(participantsHashes[_times]) % participantsCount[_times]];\n', '        participantsCount[_times] = 0;\n', '        uint256 winner2Reward = lastFiredFund[_times].div(100).mul(4);\n', '        msg.sender.transfer(winner2Reward);\n', '        lastFiredWinner[_times] = msg.sender;\n', '        lastFiredWinnerReward[_times] = winner2Reward;\n', '        emit Winner2(msg.sender, _times, currentCounter[_times], winner2Reward);\n', '        lastFiredStep[_times] = 1;\n', '        currentCounter[_times]++;\n', '    }\n', '\n', '    function _getRandomNumber(uint _round) view private returns (uint256){\n', '        return uint256(keccak256(\n', '                participantsHashes[0],\n', '                participantsHashes[1],\n', '                participantsHashes[2],\n', '                participantsHashes[3],\n', '                participantsHashes[4],\n', '                msg.sender\n', '            )) % _round;\n', '    }\n', '\n', '    function getRandomNumber(uint _round) public payable returns (uint256){\n', '        uint256 tokenBalance = luckyYouToken.balanceOf(msg.sender);\n', '        if (tokenBalance >= 100000 * 10 ** 18)\n', '        {\n', '            return _getRandomNumber(_round);\n', '        } else if (msg.value >= basePrice) {\n', '            randomNumberIncome += msg.value;\n', '            return _getRandomNumber(_round);\n', '        } else {\n', '            revert();\n', '            return 0;\n', '        }\n', '    }\n', '    //in case some bugs\n', '    function kill() public {//for test\n', '        if (msg.sender == owner)\n', '        {\n', '            selfdestruct(owner);\n', '        }\n', '    }\n', '}']