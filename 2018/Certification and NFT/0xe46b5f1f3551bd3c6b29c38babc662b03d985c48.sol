['pragma solidity 0.4.19;\n', '\n', 'contract DeusETH {\n', '    using SafeMath for uint256;\n', '\n', '    struct Citizen {\n', '        uint8 state; // 1 - living tokens, 0 - dead tokens\n', '        address holder;\n', '        uint8 branch;\n', '        bool isExist;\n', '    }\n', '\n', '    //max token supply\n', '    uint256 public cap = 50;\n', '\n', '    //2592000 - it is 1 month\n', '    uint256 public timeWithoutUpdate = 2592000;\n', '\n', '    //token price\n', '    uint256 public rate = 0.3 ether;\n', '\n', '    // amount of raised money in wei for FundsKeeper\n', '    uint256 public weiRaised;\n', '\n', '    // address where funds are collected\n', '    address public fundsKeeper;\n', '\n', '    //address of Episode Manager\n', '    address public episodeManager;\n', '    bool public managerSet = false;\n', '\n', '    //address of StockExchange\n', '    address stock;\n', '    bool public stockSet = false;\n', '\n', '    address public owner;\n', '\n', '    bool public started = false;\n', '    bool public gameOver = false;\n', '    bool public gameOverByUser = false;\n', '\n', '    uint256 public totalSupply = 0;\n', '    uint256 public livingSupply = 0;\n', '\n', '    mapping(uint256 => Citizen) public citizens;\n', '\n', '    //using for userFinalize\n', '    uint256 public timestamp = 0;\n', '\n', '    event TokenState(uint256 indexed id, uint8 state);\n', '    event TokenHolder(uint256 indexed id, address holder);\n', '    event TokenBranch(uint256 indexed id, uint8 branch);\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyEpisodeManager() {\n', '        require(msg.sender == episodeManager);\n', '        _;\n', '    }\n', '\n', '    function DeusETH(address _fundsKeeper) public {\n', '        require(_fundsKeeper != address(0));\n', '        owner = msg.sender;\n', '        fundsKeeper = _fundsKeeper;\n', '        timestamp = now;\n', '    }\n', '\n', '    // fallback function not use to buy token\n', '    function () external payable {\n', '        revert();\n', '    }\n', '\n', '    function setEpisodeManager(address _episodeManager) public onlyOwner {\n', '        require(!managerSet);\n', '        episodeManager = _episodeManager;\n', '        managerSet = true;\n', '    }\n', '\n', '    function setStock(address _stock) public onlyOwner {\n', '        require(!stockSet);\n', '        stock = _stock;\n', '        stockSet = true;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function livingSupply() public view returns (uint256) {\n', '        return livingSupply;\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(uint256 _id) public payable {\n', '        require(!started);\n', '        require(!gameOver);\n', '        require(!gameOverByUser);\n', '        require(_id > 0 && _id <= cap);\n', '        require(citizens[_id].isExist == false);\n', '\n', '        require(msg.value == rate);\n', '        uint256 weiAmount = msg.value;\n', '\n', '        // update weiRaised\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        totalSupply = totalSupply.add(1);\n', '        livingSupply = livingSupply.add(1);\n', '\n', '        createCitizen(_id, msg.sender);\n', '        timestamp = now;\n', '        TokenHolder(_id, msg.sender);\n', '        TokenState(_id, 1);\n', '        TokenBranch(_id, 1);\n', '        forwardFunds();\n', '    }\n', '\n', '    function changeState(uint256 _id, uint8 _state) public onlyEpisodeManager returns (bool) {\n', '        require(started);\n', '        require(!gameOver);\n', '        require(!gameOverByUser);\n', '        require(_id > 0 && _id <= cap);\n', '        require(_state <= 1);\n', '        require(citizens[_id].state != _state);\n', '\n', '        citizens[_id].state = _state;\n', '        TokenState(_id, _state);\n', '        timestamp = now;\n', '        if (_state == 0) {\n', '            livingSupply--;\n', '        } else {\n', '            livingSupply++;\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function changeHolder(uint256 _id, address _newholder) public returns (bool) {\n', '        require(!gameOver);\n', '        require(!gameOverByUser);\n', '        require(_id > 0 && _id <= cap);\n', '        require((citizens[_id].holder == msg.sender) || (stock == msg.sender));\n', '        require(_newholder != address(0));\n', '        citizens[_id].holder = _newholder;\n', '        TokenHolder(_id, _newholder);\n', '        return true;\n', '    }\n', '\n', '    function changeBranch(uint256 _id, uint8 _branch) public onlyEpisodeManager returns (bool) {\n', '        require(started);\n', '        require(!gameOver);\n', '        require(!gameOverByUser);\n', '        require(_id > 0 && _id <= cap);\n', '        require(_branch > 0);\n', '        citizens[_id].branch = _branch;\n', '        TokenBranch(_id, _branch);\n', '        return true;\n', '    }\n', '\n', '    function start() public onlyOwner {\n', '        require(!started);\n', '        started = true;\n', '    }\n', '\n', '    function finalize() public onlyOwner {\n', '        require(!gameOverByUser);\n', '        gameOver = true;\n', '    }\n', '\n', '    function userFinalize() public {\n', '        require(now > (timestamp + timeWithoutUpdate));\n', '        require(!gameOver);\n', '        gameOverByUser = true;\n', '    }\n', '\n', '    function checkGameOver() public view returns (bool) {\n', '        return gameOver;\n', '    }\n', '\n', '    function checkGameOverByUser() public view returns (bool) {\n', '        return gameOverByUser;\n', '    }\n', '\n', '    function changeOwner(address _newOwner) public onlyOwner returns (bool) {\n', '        require(_newOwner != address(0));\n', '        owner = _newOwner;\n', '        return true;\n', '    }\n', '\n', '    function getState(uint256 _id) public view returns (uint256) {\n', '        require(_id > 0 && _id <= cap);\n', '        return citizens[_id].state;\n', '    }\n', '\n', '    function getHolder(uint256 _id) public view returns (address) {\n', '        require(_id > 0 && _id <= cap);\n', '        return citizens[_id].holder;\n', '    }\n', '\n', '    function getNowTokenPrice() public view returns (uint256) {\n', '        return rate;\n', '    }\n', '\n', '    function allStates() public view returns (uint256[], address[], uint256[]) {\n', '        uint256[] memory a = new uint256[](50);\n', '        address[] memory b = new address[](50);\n', '        uint256[] memory c = new uint256[](50);\n', '\n', '        for (uint i = 0; i < a.length; i++) {\n', '            a[i] = citizens[i+1].state;\n', '            b[i] = citizens[i+1].holder;\n', '            c[i] = citizens[i+1].branch;\n', '        }\n', '\n', '        return (a, b, c);\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    // override to create custom fund forwarding mechanisms\n', '    function forwardFunds() internal {\n', '        fundsKeeper.transfer(msg.value);\n', '    }\n', '\n', '    function createCitizen(uint256 _id, address _holder) internal returns (uint256) {\n', '        require(!started);\n', '        require(_id > 0 && _id <= cap);\n', '        require(_holder != address(0));\n', '        citizens[_id].state = 1;\n', '        citizens[_id].holder = _holder;\n', '        citizens[_id].branch = 1;\n', '        citizens[_id].isExist = true;\n', '        return _id;\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']