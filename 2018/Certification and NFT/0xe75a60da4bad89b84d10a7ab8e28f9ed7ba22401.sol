['pragma solidity ^0.4.21;\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'interface P3DTakeout {\n', '    function buyTokens() external payable;\n', '}\n', '\n', 'contract Betting {\n', '    using SafeMath for uint256; //using safemath\n', '\n', '    address public owner; //owner address\n', '    address house_takeout = 0xf783A81F046448c38f3c863885D9e99D10209779;\n', '    P3DTakeout P3DContract_;\n', '\n', '    uint public winnerPoolTotal;\n', '    string public constant version = "0.2.3";\n', '\n', '    struct chronus_info {\n', '        bool  betting_open; // boolean: check if betting is open\n', '        bool  race_start; //boolean: check if race has started\n', '        bool  race_end; //boolean: check if race has ended\n', '        bool  voided_bet; //boolean: check if race has been voided\n', '        uint32  starting_time; // timestamp of when the race starts\n', '        uint32  betting_duration;\n', '        uint32  race_duration; // duration of the race\n', '        uint32 voided_timestamp;\n', '    }\n', '\n', '    struct horses_info{\n', '        int64  BTC_delta; //horses.BTC delta value\n', '        int64  ETH_delta; //horses.ETH delta value\n', '        int64  LTC_delta; //horses.LTC delta value\n', '        bytes32 BTC; //32-bytes equivalent of horses.BTC\n', '        bytes32 ETH; //32-bytes equivalent of horses.ETH\n', '        bytes32 LTC;  //32-bytes equivalent of horses.LTC\n', '    }\n', '\n', '    struct bet_info{\n', '        bytes32 horse; // coin on which amount is bet on\n', '        uint amount; // amount bet by Bettor\n', '    }\n', '    struct coin_info{\n', '        uint256 pre; // locking price\n', '        uint256 post; // ending price\n', '        uint160 total; // total coin pool\n', '        uint32 count; // number of bets\n', '        bool price_check;\n', '    }\n', '    struct voter_info {\n', '        uint160 total_bet; //total amount of bet placed\n', '        bool rewarded; // boolean: check for double spending\n', '        mapping(bytes32=>uint) bets; //array of bets\n', '    }\n', '\n', '    mapping (bytes32 => coin_info) public coinIndex; // mapping coins with pool information\n', '    mapping (address => voter_info) voterIndex; // mapping voter address with Bettor information\n', '\n', '    uint public total_reward; // total reward to be awarded\n', '    uint32 total_bettors;\n', '    mapping (bytes32 => bool) public winner_horse;\n', '\n', '\n', '    // tracking events\n', '    event Deposit(address _from, uint256 _value, bytes32 _horse, uint256 _date);\n', '    event Withdraw(address _to, uint256 _value);\n', '    event PriceCallback(bytes32 coin_pointer, uint256 result, bool isPrePrice);\n', '    event RefundEnabled(string reason);\n', '\n', '    // constructor\n', '    constructor() public payable {\n', '        \n', '        owner = msg.sender;\n', '        \n', '        horses.BTC = bytes32("BTC");\n', '        horses.ETH = bytes32("ETH");\n', '        horses.LTC = bytes32("LTC");\n', '        \n', '        P3DContract_ = P3DTakeout(0x72b2670e55139934D6445348DC6EaB4089B12576);\n', '    }\n', '\n', '    // data access structures\n', '    horses_info public horses;\n', '    chronus_info public chronus;\n', '\n', '    // modifiers for restricting access to methods\n', '    modifier onlyOwner {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier duringBetting {\n', '        require(chronus.betting_open);\n', '        require(now < chronus.starting_time + chronus.betting_duration);\n', '        _;\n', '    }\n', '\n', '    modifier beforeBetting {\n', '        require(!chronus.betting_open && !chronus.race_start);\n', '        _;\n', '    }\n', '\n', '    modifier afterRace {\n', '        require(chronus.race_end);\n', '        _;\n', '    }\n', '\n', '    //function to change owner\n', '    function changeOwnership(address _newOwner) onlyOwner external {\n', '        owner = _newOwner;\n', '    }\n', '\n', '    function priceCallback (bytes32 coin_pointer, uint256 result, bool isPrePrice ) external onlyOwner {\n', '        require (!chronus.race_end);\n', '        emit PriceCallback(coin_pointer, result, isPrePrice);\n', '        chronus.race_start = true;\n', '        chronus.betting_open = false;\n', '        if (isPrePrice) {\n', '            if (now >= chronus.starting_time+chronus.betting_duration+ 60 minutes) {\n', '                emit RefundEnabled("Late start price");\n', '                forceVoidRace();\n', '            } else {\n', '                coinIndex[coin_pointer].pre = result;\n', '            }\n', '        } else if (!isPrePrice){\n', '            if (coinIndex[coin_pointer].pre > 0 ){\n', '                if (now >= chronus.starting_time+chronus.race_duration+ 60 minutes) {\n', '                    emit RefundEnabled("Late end price");\n', '                    forceVoidRace();\n', '                } else {\n', '                    coinIndex[coin_pointer].post = result;\n', '                    coinIndex[coin_pointer].price_check = true;\n', '\n', '                    if (coinIndex[horses.ETH].price_check && coinIndex[horses.BTC].price_check && coinIndex[horses.LTC].price_check) {\n', '                        reward();\n', '                    }\n', '                }\n', '            } else {\n', '                emit RefundEnabled("End price came before start price");\n', '                forceVoidRace();\n', '            }\n', '        }\n', '    }\n', '\n', '    // place a bet on a coin(horse) lockBetting\n', '    function placeBet(bytes32 horse) external duringBetting payable  {\n', '        require(msg.value >= 0.01 ether);\n', '        if (voterIndex[msg.sender].total_bet==0) {\n', '            total_bettors+=1;\n', '        }\n', '        uint _newAmount = voterIndex[msg.sender].bets[horse] + msg.value;\n', '        voterIndex[msg.sender].bets[horse] = _newAmount;\n', '        voterIndex[msg.sender].total_bet += uint160(msg.value);\n', '        uint160 _newTotal = coinIndex[horse].total + uint160(msg.value);\n', '        uint32 _newCount = coinIndex[horse].count + 1;\n', '        coinIndex[horse].total = _newTotal;\n', '        coinIndex[horse].count = _newCount;\n', '        emit Deposit(msg.sender, msg.value, horse, now);\n', '    }\n', '\n', '    // fallback method for accepting payments\n', '    function () private payable {}\n', '\n', '    // method to place the oraclize queries\n', '    function setupRace(uint32 _bettingDuration, uint32 _raceDuration) onlyOwner beforeBetting external payable {\n', '            chronus.starting_time = uint32(block.timestamp);\n', '            chronus.betting_open = true;\n', '            chronus.betting_duration = _bettingDuration;\n', '            chronus.race_duration = _raceDuration;\n', '    }\n', '\n', '    // method to calculate reward (called internally by callback)\n', '    function reward() internal {\n', '        /*\n', '        calculating the difference in price with a precision of 5 digits\n', '        not using safemath since signed integers are handled\n', '        */\n', '        horses.BTC_delta = int64(coinIndex[horses.BTC].post - coinIndex[horses.BTC].pre)*100000/int64(coinIndex[horses.BTC].pre);\n', '        horses.ETH_delta = int64(coinIndex[horses.ETH].post - coinIndex[horses.ETH].pre)*100000/int64(coinIndex[horses.ETH].pre);\n', '        horses.LTC_delta = int64(coinIndex[horses.LTC].post - coinIndex[horses.LTC].pre)*100000/int64(coinIndex[horses.LTC].pre);\n', '\n', '        total_reward = (coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total);\n', '        if (total_bettors <= 1) {\n', '            emit RefundEnabled("Not enough participants");\n', '            forceVoidRace();\n', '        } else {\n', '            // house takeout\n', '            uint house_fee = total_reward.mul(5).div(100);\n', '            require(house_fee < address(this).balance);\n', '            total_reward = total_reward.sub(house_fee);\n', '            house_takeout.transfer(house_fee);\n', '            \n', '            // p3d takeout\n', '            uint p3d_fee = house_fee/2;\n', '            require(p3d_fee < address(this).balance);\n', '            total_reward = total_reward.sub(p3d_fee);\n', '            P3DContract_.buyTokens.value(p3d_fee)();\n', '        }\n', '\n', '        if (horses.BTC_delta > horses.ETH_delta) {\n', '            if (horses.BTC_delta > horses.LTC_delta) {\n', '                winner_horse[horses.BTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.BTC].total;\n', '            }\n', '            else if(horses.LTC_delta > horses.BTC_delta) {\n', '                winner_horse[horses.LTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.LTC].total;\n', '            } else {\n', '                winner_horse[horses.BTC] = true;\n', '                winner_horse[horses.LTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.BTC].total + (coinIndex[horses.LTC].total);\n', '            }\n', '        } else if(horses.ETH_delta > horses.BTC_delta) {\n', '            if (horses.ETH_delta > horses.LTC_delta) {\n', '                winner_horse[horses.ETH] = true;\n', '                winnerPoolTotal = coinIndex[horses.ETH].total;\n', '            }\n', '            else if (horses.LTC_delta > horses.ETH_delta) {\n', '                winner_horse[horses.LTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.LTC].total;\n', '            } else {\n', '                winner_horse[horses.ETH] = true;\n', '                winner_horse[horses.LTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.LTC].total);\n', '            }\n', '        } else {\n', '            if (horses.LTC_delta > horses.ETH_delta) {\n', '                winner_horse[horses.LTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.LTC].total;\n', '            } else if(horses.LTC_delta < horses.ETH_delta){\n', '                winner_horse[horses.ETH] = true;\n', '                winner_horse[horses.BTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total);\n', '            } else {\n', '                winner_horse[horses.LTC] = true;\n', '                winner_horse[horses.ETH] = true;\n', '                winner_horse[horses.BTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total) + (coinIndex[horses.LTC].total);\n', '            }\n', '        }\n', '        chronus.race_end = true;\n', '    }\n', '\n', '    // method to calculate an invidual&#39;s reward\n', '    function calculateReward(address candidate) internal afterRace constant returns(uint winner_reward) {\n', '        voter_info storage bettor = voterIndex[candidate];\n', '        if(chronus.voided_bet) {\n', '            winner_reward = bettor.total_bet;\n', '        } else {\n', '            uint winning_bet_total;\n', '            if(winner_horse[horses.BTC]) {\n', '                winning_bet_total += bettor.bets[horses.BTC];\n', '            } if(winner_horse[horses.ETH]) {\n', '                winning_bet_total += bettor.bets[horses.ETH];\n', '            } if(winner_horse[horses.LTC]) {\n', '                winning_bet_total += bettor.bets[horses.LTC];\n', '            }\n', '            winner_reward += (((total_reward.mul(10000000)).div(winnerPoolTotal)).mul(winning_bet_total)).div(10000000);\n', '        }\n', '    }\n', '\n', '    // method to just check the reward amount\n', '    function checkReward() afterRace external constant returns (uint) {\n', '        require(!voterIndex[msg.sender].rewarded);\n', '        return calculateReward(msg.sender);\n', '    }\n', '\n', '    // method to claim the reward amount\n', '    function claim_reward() afterRace external {\n', '        require(!voterIndex[msg.sender].rewarded);\n', '        uint transfer_amount = calculateReward(msg.sender);\n', '        require(address(this).balance >= transfer_amount);\n', '        voterIndex[msg.sender].rewarded = true;\n', '        msg.sender.transfer(transfer_amount);\n', '        emit Withdraw(msg.sender, transfer_amount);\n', '    }\n', '\n', '    function forceVoidRace() internal {\n', '        chronus.voided_bet=true;\n', '        chronus.race_end = true;\n', '        chronus.voided_timestamp=uint32(now);\n', '    }\n', '\n', '    // exposing the coin pool details for DApp\n', '    function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {\n', '        uint256 coinPrePrice;\n', '        uint256 coinPostPrice;\n', '        if (coinIndex[horses.ETH].pre > 0 && coinIndex[horses.BTC].pre > 0 && coinIndex[horses.LTC].pre > 0) {\n', '            coinPrePrice = coinIndex[index].pre;\n', '        } \n', '        if (coinIndex[horses.ETH].post > 0 && coinIndex[horses.BTC].post > 0 && coinIndex[horses.LTC].post > 0) {\n', '            coinPostPrice = coinIndex[index].post;\n', '        }\n', '        return (coinIndex[index].total, coinPrePrice, coinPostPrice, coinIndex[index].price_check, voterIndex[candidate].bets[index]);\n', '    }\n', '\n', '    // exposing the total reward amount for DApp\n', '    function reward_total() external constant returns (uint) {\n', '        return ((coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total));\n', '    }\n', '\n', '    // in case of any errors in race, enable full refund for the Bettors to claim\n', '    function refund() external onlyOwner {\n', '        require(now > chronus.starting_time + chronus.race_duration);\n', '        require((chronus.betting_open && !chronus.race_start)\n', '            || (chronus.race_start && !chronus.race_end));\n', '        chronus.voided_bet = true;\n', '        chronus.race_end = true;\n', '        chronus.voided_timestamp=uint32(now);\n', '    }\n', '\n', '    // method to claim unclaimed winnings after 30 day notice period\n', '    function recovery() external onlyOwner{\n', '        require((chronus.race_end && now > chronus.starting_time + chronus.race_duration + (30 days))\n', '            || (chronus.voided_bet && now > chronus.voided_timestamp + (30 days)));\n', '        house_takeout.transfer(address(this).balance);\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'interface P3DTakeout {\n', '    function buyTokens() external payable;\n', '}\n', '\n', 'contract Betting {\n', '    using SafeMath for uint256; //using safemath\n', '\n', '    address public owner; //owner address\n', '    address house_takeout = 0xf783A81F046448c38f3c863885D9e99D10209779;\n', '    P3DTakeout P3DContract_;\n', '\n', '    uint public winnerPoolTotal;\n', '    string public constant version = "0.2.3";\n', '\n', '    struct chronus_info {\n', '        bool  betting_open; // boolean: check if betting is open\n', '        bool  race_start; //boolean: check if race has started\n', '        bool  race_end; //boolean: check if race has ended\n', '        bool  voided_bet; //boolean: check if race has been voided\n', '        uint32  starting_time; // timestamp of when the race starts\n', '        uint32  betting_duration;\n', '        uint32  race_duration; // duration of the race\n', '        uint32 voided_timestamp;\n', '    }\n', '\n', '    struct horses_info{\n', '        int64  BTC_delta; //horses.BTC delta value\n', '        int64  ETH_delta; //horses.ETH delta value\n', '        int64  LTC_delta; //horses.LTC delta value\n', '        bytes32 BTC; //32-bytes equivalent of horses.BTC\n', '        bytes32 ETH; //32-bytes equivalent of horses.ETH\n', '        bytes32 LTC;  //32-bytes equivalent of horses.LTC\n', '    }\n', '\n', '    struct bet_info{\n', '        bytes32 horse; // coin on which amount is bet on\n', '        uint amount; // amount bet by Bettor\n', '    }\n', '    struct coin_info{\n', '        uint256 pre; // locking price\n', '        uint256 post; // ending price\n', '        uint160 total; // total coin pool\n', '        uint32 count; // number of bets\n', '        bool price_check;\n', '    }\n', '    struct voter_info {\n', '        uint160 total_bet; //total amount of bet placed\n', '        bool rewarded; // boolean: check for double spending\n', '        mapping(bytes32=>uint) bets; //array of bets\n', '    }\n', '\n', '    mapping (bytes32 => coin_info) public coinIndex; // mapping coins with pool information\n', '    mapping (address => voter_info) voterIndex; // mapping voter address with Bettor information\n', '\n', '    uint public total_reward; // total reward to be awarded\n', '    uint32 total_bettors;\n', '    mapping (bytes32 => bool) public winner_horse;\n', '\n', '\n', '    // tracking events\n', '    event Deposit(address _from, uint256 _value, bytes32 _horse, uint256 _date);\n', '    event Withdraw(address _to, uint256 _value);\n', '    event PriceCallback(bytes32 coin_pointer, uint256 result, bool isPrePrice);\n', '    event RefundEnabled(string reason);\n', '\n', '    // constructor\n', '    constructor() public payable {\n', '        \n', '        owner = msg.sender;\n', '        \n', '        horses.BTC = bytes32("BTC");\n', '        horses.ETH = bytes32("ETH");\n', '        horses.LTC = bytes32("LTC");\n', '        \n', '        P3DContract_ = P3DTakeout(0x72b2670e55139934D6445348DC6EaB4089B12576);\n', '    }\n', '\n', '    // data access structures\n', '    horses_info public horses;\n', '    chronus_info public chronus;\n', '\n', '    // modifiers for restricting access to methods\n', '    modifier onlyOwner {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier duringBetting {\n', '        require(chronus.betting_open);\n', '        require(now < chronus.starting_time + chronus.betting_duration);\n', '        _;\n', '    }\n', '\n', '    modifier beforeBetting {\n', '        require(!chronus.betting_open && !chronus.race_start);\n', '        _;\n', '    }\n', '\n', '    modifier afterRace {\n', '        require(chronus.race_end);\n', '        _;\n', '    }\n', '\n', '    //function to change owner\n', '    function changeOwnership(address _newOwner) onlyOwner external {\n', '        owner = _newOwner;\n', '    }\n', '\n', '    function priceCallback (bytes32 coin_pointer, uint256 result, bool isPrePrice ) external onlyOwner {\n', '        require (!chronus.race_end);\n', '        emit PriceCallback(coin_pointer, result, isPrePrice);\n', '        chronus.race_start = true;\n', '        chronus.betting_open = false;\n', '        if (isPrePrice) {\n', '            if (now >= chronus.starting_time+chronus.betting_duration+ 60 minutes) {\n', '                emit RefundEnabled("Late start price");\n', '                forceVoidRace();\n', '            } else {\n', '                coinIndex[coin_pointer].pre = result;\n', '            }\n', '        } else if (!isPrePrice){\n', '            if (coinIndex[coin_pointer].pre > 0 ){\n', '                if (now >= chronus.starting_time+chronus.race_duration+ 60 minutes) {\n', '                    emit RefundEnabled("Late end price");\n', '                    forceVoidRace();\n', '                } else {\n', '                    coinIndex[coin_pointer].post = result;\n', '                    coinIndex[coin_pointer].price_check = true;\n', '\n', '                    if (coinIndex[horses.ETH].price_check && coinIndex[horses.BTC].price_check && coinIndex[horses.LTC].price_check) {\n', '                        reward();\n', '                    }\n', '                }\n', '            } else {\n', '                emit RefundEnabled("End price came before start price");\n', '                forceVoidRace();\n', '            }\n', '        }\n', '    }\n', '\n', '    // place a bet on a coin(horse) lockBetting\n', '    function placeBet(bytes32 horse) external duringBetting payable  {\n', '        require(msg.value >= 0.01 ether);\n', '        if (voterIndex[msg.sender].total_bet==0) {\n', '            total_bettors+=1;\n', '        }\n', '        uint _newAmount = voterIndex[msg.sender].bets[horse] + msg.value;\n', '        voterIndex[msg.sender].bets[horse] = _newAmount;\n', '        voterIndex[msg.sender].total_bet += uint160(msg.value);\n', '        uint160 _newTotal = coinIndex[horse].total + uint160(msg.value);\n', '        uint32 _newCount = coinIndex[horse].count + 1;\n', '        coinIndex[horse].total = _newTotal;\n', '        coinIndex[horse].count = _newCount;\n', '        emit Deposit(msg.sender, msg.value, horse, now);\n', '    }\n', '\n', '    // fallback method for accepting payments\n', '    function () private payable {}\n', '\n', '    // method to place the oraclize queries\n', '    function setupRace(uint32 _bettingDuration, uint32 _raceDuration) onlyOwner beforeBetting external payable {\n', '            chronus.starting_time = uint32(block.timestamp);\n', '            chronus.betting_open = true;\n', '            chronus.betting_duration = _bettingDuration;\n', '            chronus.race_duration = _raceDuration;\n', '    }\n', '\n', '    // method to calculate reward (called internally by callback)\n', '    function reward() internal {\n', '        /*\n', '        calculating the difference in price with a precision of 5 digits\n', '        not using safemath since signed integers are handled\n', '        */\n', '        horses.BTC_delta = int64(coinIndex[horses.BTC].post - coinIndex[horses.BTC].pre)*100000/int64(coinIndex[horses.BTC].pre);\n', '        horses.ETH_delta = int64(coinIndex[horses.ETH].post - coinIndex[horses.ETH].pre)*100000/int64(coinIndex[horses.ETH].pre);\n', '        horses.LTC_delta = int64(coinIndex[horses.LTC].post - coinIndex[horses.LTC].pre)*100000/int64(coinIndex[horses.LTC].pre);\n', '\n', '        total_reward = (coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total);\n', '        if (total_bettors <= 1) {\n', '            emit RefundEnabled("Not enough participants");\n', '            forceVoidRace();\n', '        } else {\n', '            // house takeout\n', '            uint house_fee = total_reward.mul(5).div(100);\n', '            require(house_fee < address(this).balance);\n', '            total_reward = total_reward.sub(house_fee);\n', '            house_takeout.transfer(house_fee);\n', '            \n', '            // p3d takeout\n', '            uint p3d_fee = house_fee/2;\n', '            require(p3d_fee < address(this).balance);\n', '            total_reward = total_reward.sub(p3d_fee);\n', '            P3DContract_.buyTokens.value(p3d_fee)();\n', '        }\n', '\n', '        if (horses.BTC_delta > horses.ETH_delta) {\n', '            if (horses.BTC_delta > horses.LTC_delta) {\n', '                winner_horse[horses.BTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.BTC].total;\n', '            }\n', '            else if(horses.LTC_delta > horses.BTC_delta) {\n', '                winner_horse[horses.LTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.LTC].total;\n', '            } else {\n', '                winner_horse[horses.BTC] = true;\n', '                winner_horse[horses.LTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.BTC].total + (coinIndex[horses.LTC].total);\n', '            }\n', '        } else if(horses.ETH_delta > horses.BTC_delta) {\n', '            if (horses.ETH_delta > horses.LTC_delta) {\n', '                winner_horse[horses.ETH] = true;\n', '                winnerPoolTotal = coinIndex[horses.ETH].total;\n', '            }\n', '            else if (horses.LTC_delta > horses.ETH_delta) {\n', '                winner_horse[horses.LTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.LTC].total;\n', '            } else {\n', '                winner_horse[horses.ETH] = true;\n', '                winner_horse[horses.LTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.LTC].total);\n', '            }\n', '        } else {\n', '            if (horses.LTC_delta > horses.ETH_delta) {\n', '                winner_horse[horses.LTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.LTC].total;\n', '            } else if(horses.LTC_delta < horses.ETH_delta){\n', '                winner_horse[horses.ETH] = true;\n', '                winner_horse[horses.BTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total);\n', '            } else {\n', '                winner_horse[horses.LTC] = true;\n', '                winner_horse[horses.ETH] = true;\n', '                winner_horse[horses.BTC] = true;\n', '                winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total) + (coinIndex[horses.LTC].total);\n', '            }\n', '        }\n', '        chronus.race_end = true;\n', '    }\n', '\n', "    // method to calculate an invidual's reward\n", '    function calculateReward(address candidate) internal afterRace constant returns(uint winner_reward) {\n', '        voter_info storage bettor = voterIndex[candidate];\n', '        if(chronus.voided_bet) {\n', '            winner_reward = bettor.total_bet;\n', '        } else {\n', '            uint winning_bet_total;\n', '            if(winner_horse[horses.BTC]) {\n', '                winning_bet_total += bettor.bets[horses.BTC];\n', '            } if(winner_horse[horses.ETH]) {\n', '                winning_bet_total += bettor.bets[horses.ETH];\n', '            } if(winner_horse[horses.LTC]) {\n', '                winning_bet_total += bettor.bets[horses.LTC];\n', '            }\n', '            winner_reward += (((total_reward.mul(10000000)).div(winnerPoolTotal)).mul(winning_bet_total)).div(10000000);\n', '        }\n', '    }\n', '\n', '    // method to just check the reward amount\n', '    function checkReward() afterRace external constant returns (uint) {\n', '        require(!voterIndex[msg.sender].rewarded);\n', '        return calculateReward(msg.sender);\n', '    }\n', '\n', '    // method to claim the reward amount\n', '    function claim_reward() afterRace external {\n', '        require(!voterIndex[msg.sender].rewarded);\n', '        uint transfer_amount = calculateReward(msg.sender);\n', '        require(address(this).balance >= transfer_amount);\n', '        voterIndex[msg.sender].rewarded = true;\n', '        msg.sender.transfer(transfer_amount);\n', '        emit Withdraw(msg.sender, transfer_amount);\n', '    }\n', '\n', '    function forceVoidRace() internal {\n', '        chronus.voided_bet=true;\n', '        chronus.race_end = true;\n', '        chronus.voided_timestamp=uint32(now);\n', '    }\n', '\n', '    // exposing the coin pool details for DApp\n', '    function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {\n', '        uint256 coinPrePrice;\n', '        uint256 coinPostPrice;\n', '        if (coinIndex[horses.ETH].pre > 0 && coinIndex[horses.BTC].pre > 0 && coinIndex[horses.LTC].pre > 0) {\n', '            coinPrePrice = coinIndex[index].pre;\n', '        } \n', '        if (coinIndex[horses.ETH].post > 0 && coinIndex[horses.BTC].post > 0 && coinIndex[horses.LTC].post > 0) {\n', '            coinPostPrice = coinIndex[index].post;\n', '        }\n', '        return (coinIndex[index].total, coinPrePrice, coinPostPrice, coinIndex[index].price_check, voterIndex[candidate].bets[index]);\n', '    }\n', '\n', '    // exposing the total reward amount for DApp\n', '    function reward_total() external constant returns (uint) {\n', '        return ((coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total));\n', '    }\n', '\n', '    // in case of any errors in race, enable full refund for the Bettors to claim\n', '    function refund() external onlyOwner {\n', '        require(now > chronus.starting_time + chronus.race_duration);\n', '        require((chronus.betting_open && !chronus.race_start)\n', '            || (chronus.race_start && !chronus.race_end));\n', '        chronus.voided_bet = true;\n', '        chronus.race_end = true;\n', '        chronus.voided_timestamp=uint32(now);\n', '    }\n', '\n', '    // method to claim unclaimed winnings after 30 day notice period\n', '    function recovery() external onlyOwner{\n', '        require((chronus.race_end && now > chronus.starting_time + chronus.race_duration + (30 days))\n', '            || (chronus.voided_bet && now > chronus.voided_timestamp + (30 days)));\n', '        house_takeout.transfer(address(this).balance);\n', '    }\n', '}']
