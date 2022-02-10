['pragma solidity 0.4.25;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '        // benefit is lost if &#39;b&#39; is also tested.\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    mapping(address => bool) owners;\n', '    mapping(address => bool) managers;\n', '\n', '    event OwnerAdded(address indexed newOwner);\n', '    event OwnerDeleted(address indexed owner);\n', '    event ManagerAdded(address indexed newOwner);\n', '    event ManagerDeleted(address indexed owner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owners[msg.sender] = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(msg.sender));\n', '        _;\n', '    }\n', '\n', '    modifier onlyManager() {\n', '        require(isManager(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function addOwner(address _newOwner) external onlyOwner {\n', '        require(_newOwner != address(0));\n', '        owners[_newOwner] = true;\n', '        emit OwnerAdded(_newOwner);\n', '    }\n', '\n', '    function delOwner(address _owner) external onlyOwner {\n', '        require(owners[_owner]);\n', '        owners[_owner] = false;\n', '        emit OwnerDeleted(_owner);\n', '    }\n', '\n', '\n', '    function addManager(address _manager) external onlyOwner {\n', '        require(_manager != address(0));\n', '        managers[_manager] = true;\n', '        emit ManagerAdded(_manager);\n', '    }\n', '\n', '    function delManager(address _manager) external onlyOwner {\n', '        require(managers[_manager]);\n', '        managers[_manager] = false;\n', '        emit ManagerDeleted(_manager);\n', '    }\n', '\n', '    function isOwner(address _owner) public view returns (bool) {\n', '        return owners[_owner];\n', '    }\n', '\n', '    function isManager(address _manager) public view returns (bool) {\n', '        return managers[_manager];\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title TokenTimelock\n', ' * @dev TokenTimelock is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract Escrow is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    struct Stage {\n', '        uint releaseTime;\n', '        uint percent;\n', '        bool transferred;\n', '    }\n', '\n', '    mapping (uint => Stage) public stages;\n', '    uint public stageCount;\n', '\n', '    uint public stopDay;\n', '    uint public startBalance = 0;\n', '\n', '\n', '    constructor(uint _stopDay) public {\n', '        stopDay = _stopDay;\n', '    }\n', '\n', '    function() payable public {\n', '\n', '    }\n', '\n', '    //1% - 100, 10% - 1000 50% - 5000\n', '    function addStage(uint _releaseTime, uint _percent) onlyOwner public {\n', '        require(_percent >= 100);\n', '        require(_releaseTime > stages[stageCount].releaseTime);\n', '        stageCount++;\n', '        stages[stageCount].releaseTime = _releaseTime;\n', '        stages[stageCount].percent = _percent;\n', '    }\n', '\n', '\n', '    function getETH(uint _stage, address _to) onlyManager external {\n', '        require(stages[_stage].releaseTime < now);\n', '        require(!stages[_stage].transferred);\n', '        require(_to != address(0));\n', '\n', '        if (startBalance == 0) {\n', '            startBalance = address(this).balance;\n', '        }\n', '\n', '        uint val = valueFromPercent(startBalance, stages[_stage].percent);\n', '        stages[_stage].transferred = true;\n', '        _to.transfer(val);\n', '    }\n', '\n', '\n', '    function getAllETH(address _to) onlyManager external {\n', '        require(stopDay < now);\n', '        require(address(this).balance > 0);\n', '        require(_to != address(0));\n', '\n', '        _to.transfer(address(this).balance);\n', '    }\n', '\n', '\n', '    function transferETH(address _to) onlyOwner external {\n', '        require(address(this).balance > 0);\n', '        require(_to != address(0));\n', '        _to.transfer(address(this).balance);\n', '    }\n', '\n', '\n', '    //1% - 100, 10% - 1000 50% - 5000\n', '    function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {\n', '        uint _amount = _value.mul(_percent).div(10000);\n', '        return (_amount);\n', '    }\n', '\n', '    function setStopDay(uint _stopDay) onlyOwner external {\n', '        stopDay = _stopDay;\n', '    }\n', '}']
['pragma solidity 0.4.25;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    mapping(address => bool) owners;\n', '    mapping(address => bool) managers;\n', '\n', '    event OwnerAdded(address indexed newOwner);\n', '    event OwnerDeleted(address indexed owner);\n', '    event ManagerAdded(address indexed newOwner);\n', '    event ManagerDeleted(address indexed owner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owners[msg.sender] = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(msg.sender));\n', '        _;\n', '    }\n', '\n', '    modifier onlyManager() {\n', '        require(isManager(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function addOwner(address _newOwner) external onlyOwner {\n', '        require(_newOwner != address(0));\n', '        owners[_newOwner] = true;\n', '        emit OwnerAdded(_newOwner);\n', '    }\n', '\n', '    function delOwner(address _owner) external onlyOwner {\n', '        require(owners[_owner]);\n', '        owners[_owner] = false;\n', '        emit OwnerDeleted(_owner);\n', '    }\n', '\n', '\n', '    function addManager(address _manager) external onlyOwner {\n', '        require(_manager != address(0));\n', '        managers[_manager] = true;\n', '        emit ManagerAdded(_manager);\n', '    }\n', '\n', '    function delManager(address _manager) external onlyOwner {\n', '        require(managers[_manager]);\n', '        managers[_manager] = false;\n', '        emit ManagerDeleted(_manager);\n', '    }\n', '\n', '    function isOwner(address _owner) public view returns (bool) {\n', '        return owners[_owner];\n', '    }\n', '\n', '    function isManager(address _manager) public view returns (bool) {\n', '        return managers[_manager];\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title TokenTimelock\n', ' * @dev TokenTimelock is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract Escrow is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    struct Stage {\n', '        uint releaseTime;\n', '        uint percent;\n', '        bool transferred;\n', '    }\n', '\n', '    mapping (uint => Stage) public stages;\n', '    uint public stageCount;\n', '\n', '    uint public stopDay;\n', '    uint public startBalance = 0;\n', '\n', '\n', '    constructor(uint _stopDay) public {\n', '        stopDay = _stopDay;\n', '    }\n', '\n', '    function() payable public {\n', '\n', '    }\n', '\n', '    //1% - 100, 10% - 1000 50% - 5000\n', '    function addStage(uint _releaseTime, uint _percent) onlyOwner public {\n', '        require(_percent >= 100);\n', '        require(_releaseTime > stages[stageCount].releaseTime);\n', '        stageCount++;\n', '        stages[stageCount].releaseTime = _releaseTime;\n', '        stages[stageCount].percent = _percent;\n', '    }\n', '\n', '\n', '    function getETH(uint _stage, address _to) onlyManager external {\n', '        require(stages[_stage].releaseTime < now);\n', '        require(!stages[_stage].transferred);\n', '        require(_to != address(0));\n', '\n', '        if (startBalance == 0) {\n', '            startBalance = address(this).balance;\n', '        }\n', '\n', '        uint val = valueFromPercent(startBalance, stages[_stage].percent);\n', '        stages[_stage].transferred = true;\n', '        _to.transfer(val);\n', '    }\n', '\n', '\n', '    function getAllETH(address _to) onlyManager external {\n', '        require(stopDay < now);\n', '        require(address(this).balance > 0);\n', '        require(_to != address(0));\n', '\n', '        _to.transfer(address(this).balance);\n', '    }\n', '\n', '\n', '    function transferETH(address _to) onlyOwner external {\n', '        require(address(this).balance > 0);\n', '        require(_to != address(0));\n', '        _to.transfer(address(this).balance);\n', '    }\n', '\n', '\n', '    //1% - 100, 10% - 1000 50% - 5000\n', '    function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {\n', '        uint _amount = _value.mul(_percent).div(10000);\n', '        return (_amount);\n', '    }\n', '\n', '    function setStopDay(uint _stopDay) onlyOwner external {\n', '        stopDay = _stopDay;\n', '    }\n', '}']
