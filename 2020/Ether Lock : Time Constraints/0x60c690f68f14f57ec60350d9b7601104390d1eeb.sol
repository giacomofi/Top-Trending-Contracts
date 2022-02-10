['pragma solidity ^0.5.8;\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '     require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', 'contract Administration is SafeMath {\n', '    // ----------------------------------------------------------------------------\n', '    // Variables\n', '    // ----------------------------------------------------------------------------\n', '    address payable CEOAddress;\n', '    address public CTOAddress;\n', '    address Signer;\n', '\n', '    bool public paused = false;\n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // Events\n', '    // ----------------------------------------------------------------------------\n', '    event Pause();\n', '    event Unpause();\n', '    event CTOTransfer(address newCTO, address oldCTO);\n', '\n', '    // ---------------------------------------------------------------------------- \n', '    // Modifiers\n', '    // ----------------------------------------------------------------------------\n', '    modifier onlyCEO() {\n', '        require(msg.sender == CEOAddress);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == CEOAddress || msg.sender == CTOAddress);\n', '        _;\n', '    }\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    // ----------------------------------------------------------------------------\n', '    // Public Functions\n', '    // ----------------------------------------------------------------------------\n', '    function setCTO(address _newAdmin) public onlyCEO {\n', '        require(_newAdmin != address(0));\n', '        emit CTOTransfer(_newAdmin, CTOAddress);\n', '        CTOAddress = _newAdmin;\n', '    }\n', '\n', '    function withdrawBalance() external onlyCEO {\n', '        CEOAddress.transfer(address(this).balance);\n', '    }\n', '\n', '    function pause() public onlyAdmin whenNotPaused returns(bool) {\n', '        paused = true;\n', '        emit Pause();\n', '        return true;\n', '    }\n', '\n', '    function unpause() public onlyAdmin whenPaused returns(bool) {\n', '        paused = false;\n', '        emit Unpause();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Creative is Administration {\n', '    // ----------------------------------------------------------------------------\n', '    // Variables\n', '    // ----------------------------------------------------------------------------\n', '    struct Bet {\n', '        uint[4] amount;\n', '        uint timestamp;\n', '    }\n', '    \n', '    struct Contract {\n', '        uint result; //0-while running, 1-4 winner\n', '        uint sides;\n', '        uint StartTime;\n', '        uint BetEndTime;\n', '        uint ContractTime;\n', '        mapping(address => Bet) PlayerToBet;\n', '        mapping(address => bool) IfPlayed;\n', '        mapping(address => bool) IfClaimed;\n', '    }\n', '    \n', '    Contract[] contracts;\n', '    \n', '    uint public minBet = 10 finney;\n', '    uint public maxBet = 10000 ether;\n', '    \n', '    uint TimeFactor;\n', '    \n', '    uint public contractFee = 100 finney;\n', '    uint public taxRate = 9750;\n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // Mappings\n', '    // ----------------------------------------------------------------------------\n', '    mapping (uint => uint) TotalAmount;\n', '    mapping (uint => uint[4]) EachAmount;\n', '    mapping (uint => uint) TotalPlayers;\n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // Events\n', '    // ----------------------------------------------------------------------------\n', '    event ContractCreated(uint indexed contractId, uint sides, uint[4] eachAmount, address creator, uint contractTime, uint betEndTime);\n', '    event NewBetSuccess(address indexed player, uint indexed side, uint[4] indexed amount, uint timeFactor);\n', '    event BetAdjustSuccess(address indexed player, uint indexed side, uint[4] indexed amount, uint timeFactor);\n', '    event ContractRevealed(uint indexed contractId, uint indexed result);\n', '    event ContractClaimed(address indexed winner, uint indexed reward);\n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // Internal Functions\n', '    // ----------------------------------------------------------------------------\n', '    function _calculateTimeFactor(uint _betEndTime, uint _startTime) internal view returns (uint) {\n', '        return (_betEndTime - now)*100/(_betEndTime - _startTime);\n', '    }\n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // Public Functions\n', '    // ----------------------------------------------------------------------------\n', '    constructor(address _CTOAddress) public {\n', '        CEOAddress = msg.sender;\n', '        CTOAddress = _CTOAddress;\n', '    }\n', '    \n', '    function createContract(uint sides, uint[4] memory amounts, uint contractTime, uint betEndTime) public payable whenNotPaused returns (uint) {\n', '        require(amounts[0] > 0 || amounts[1] > 0 || amounts[2] > 0 || amounts[3] > 0, "SEER OFFICAL WARNING: At least bet on one side");\n', '        uint total = amounts[0] + amounts[1] + amounts[2] + amounts[3];\n', '        require(sides >= 2 && sides <= 4, "SEER OFFICAL WARNING: Can only have 2-4 sides");\n', '        require(msg.value >= (total + contractFee), "SEER OFFICAL WARNING: Does not send enough ETH");\n', '        require((now + 1 hours) <= betEndTime, "SEER OFFICAL WARNING: At least have one hour bet time");\n', '        require((contractTime - now)/3 >= (betEndTime - now), "SEER OFFICAL WARNING: Bet time need to be less or equal than 1/3 of total contract time");\n', '        Bet memory _bet = Bet({\n', '            amount: amounts,\n', '            timestamp: _calculateTimeFactor(betEndTime, now)\n', '        });\n', '        Contract memory _contract = Contract({\n', '           result: 0,\n', '           sides: sides,\n', '           StartTime: now,\n', '           BetEndTime: betEndTime,\n', '           ContractTime: contractTime\n', '        });\n', '        uint newContractId = contracts.push(_contract) - 1;\n', '        Contract storage newContract = contracts[newContractId];\n', '        newContract.PlayerToBet[msg.sender] = _bet;\n', '        newContract.IfPlayed[msg.sender] = true;\n', '        TotalAmount[newContractId] = total;\n', '        EachAmount[newContractId] = amounts;\n', '        TotalPlayers[newContractId] = 1;\n', '        emit ContractCreated(newContractId, sides, amounts, msg.sender, contractTime, betEndTime);\n', '        return 0;\n', '    }\n', '    \n', '    function betContract(uint contractId, uint side, uint amount) public payable whenNotPaused returns (bool) {\n', '        require(TotalAmount[contractId] > 0, "SEER OFFICAL WARNING: Contract has not been created");\n', '        require(amount >= minBet && amount <= maxBet, "SEER OFFICAL WARNING: Does not meet min or max bet requirement");\n', '        require(msg.value >= amount, "SEER OFFICAL WARNING: Does not send enough ETH");\n', '        Contract storage _contract = contracts[contractId];\n', '        require(side < _contract.sides, "SEER OFFICAL WARNING: You did not in correct side range");\n', '        require(now < _contract.BetEndTime, "SEER OFFICAL WARNING: Contract cannot be bet anymore");\n', '        require(_contract.result == 0, "SEER OFFICAL WARNING: Contact terminated");\n', '        uint timeFactor = _calculateTimeFactor(_contract.BetEndTime, _contract.StartTime);\n', '        if(_contract.IfPlayed[msg.sender] == true) {\n', '            Bet storage _bet = _contract.PlayerToBet[msg.sender];\n', '            _bet.amount[side] += amount;\n', '            _bet.timestamp = timeFactor;\n', '            EachAmount[contractId][side] += amount;\n', '            TotalAmount[contractId] += amount;\n', '            emit BetAdjustSuccess(msg.sender, side, _bet.amount, timeFactor);\n', '        } else {\n', '            uint[4] memory _amount;\n', '            _amount[side] = amount;\n', '            Bet memory _bet = Bet({\n', '                amount: _amount,\n', '                timestamp: timeFactor\n', '            });\n', '            _contract.IfPlayed[msg.sender] = true;\n', '            _contract.PlayerToBet[msg.sender] = _bet;\n', '            EachAmount[contractId][side] += amount;\n', '            TotalAmount[contractId] += amount;\n', '            TotalPlayers[contractId] += 1;\n', '            emit NewBetSuccess(msg.sender, side, _amount, timeFactor);\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function revealContract(uint contractId, uint result) public whenNotPaused onlyAdmin {\n', '        require(result >= 1 && result<= 4, "SEER OFFICAL WARNING: Cannot recogonize result");\n', '        Contract storage _contract = contracts[contractId];\n', '        require(now > _contract.ContractTime, "SEER OFFICAL WARNING: Contract cannot be revealed yet");\n', '        _contract.result = result;\n', '        emit ContractRevealed(contractId, result);\n', '    }\n', '    \n', '    function claimContract(uint contractId) public whenNotPaused returns (uint) {\n', '        require(TotalAmount[contractId] > 0, "SEER OFFICAL WARNING: Contract has not been created");\n', '        Contract storage _contract = contracts[contractId];\n', '        require(_contract.result > 0, "SEER OFFICAL WARNING: Contract has not been revealed");\n', '        require(_contract.IfPlayed[msg.sender] == true, "SEER OFFICAL WARNING: You did not play this contract");\n', '        require(_contract.IfClaimed[msg.sender] == false, "SEER OFFICAL WARNING: You already claimed reward");\n', '        uint reward;\n', '        uint[4] memory _amount = _contract.PlayerToBet[msg.sender].amount;\n', '        require(_amount[_contract.result - 1] > 0, "SEER OFFICAL WARNING: You are not qualified");\n', '        reward = _amount[_contract.result - 1]*taxRate*TotalAmount[contractId]/EachAmount[contractId][_contract.result - 1]/10000;\n', '        msg.sender.transfer(reward);\n', '        _contract.IfClaimed[msg.sender] == true;\n', '        emit ContractClaimed(msg.sender, reward);\n', '        return reward;\n', '    }\n', '    \n', '    function adjustBetLimit(uint _minBet, uint _maxBet) public onlyAdmin {\n', '        minBet = _minBet;\n', '        maxBet = _maxBet;\n', '    }\n', '    \n', '    function adjustFee(uint _fee) public onlyAdmin {\n', '        contractFee = _fee;\n', '    }\n', '    \n', '    function adjustTax(uint _tax) public onlyAdmin {\n', '        taxRate = _tax;\n', '    }\n', '    \n', '    function getContractAmount(uint contractId) public view returns (\n', '        uint totalAmount,\n', '        uint amountOne,\n', '        uint amountTwo,\n', '        uint amountThree,\n', '        uint amountFour\n', '    ) {\n', '        totalAmount = TotalAmount[contractId];\n', '        amountOne = EachAmount[contractId][0];\n', '        amountTwo = EachAmount[contractId][1];\n', '        amountThree = EachAmount[contractId][2];\n', '        amountFour = EachAmount[contractId][3];\n', '    }\n', '    \n', '    function getContractPlayerNum(uint contractId) public view returns (uint totalPlayer) {\n', '        totalPlayer = TotalPlayers[contractId];\n', '    }\n', '    \n', '    function getIfPlayed(uint contractId, address player) public view returns (bool ifPlayed) {\n', '        ifPlayed = contracts[contractId].IfPlayed[player];\n', '    }\n', '    \n', '    function getContractTime(uint contractId) public view returns (\n', '        uint contractTime,\n', '        uint betEndTime\n', '    ) {\n', '        contractTime = contracts[contractId].ContractTime;\n', '        betEndTime = contracts[contractId].BetEndTime;\n', '    }\n', '    \n', '    function getContractBet(uint contractId, address player) public view returns (\n', '        uint[4] memory amounts,\n', '        uint timeFactor\n', '    ) {\n', '        amounts = contracts[contractId].PlayerToBet[player].amount;\n', '        timeFactor = contracts[contractId].PlayerToBet[player].timestamp;\n', '    }\n', '    \n', '    function getContractResult(uint contractId) public view returns (uint result) {\n', '        result =  contracts[contractId].result;\n', '    }\n', '    \n', '    function getIfClaimed(uint contractId, address player) public view returns (bool ifClaimed) {\n', '        ifClaimed = contracts[contractId].IfClaimed[player];\n', '    }\n', '}']