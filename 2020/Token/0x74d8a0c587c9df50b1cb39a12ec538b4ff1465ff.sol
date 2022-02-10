['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-06\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface Token { \n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function balanceOf(address owner) external view returns (uint256);\n', '} \n', '\n', 'interface USDTToken {\n', '    function transfer(address _to, uint _value) external;\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    /**\n', '      * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '      * account.\n', '      */\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '      * @dev Throws if called by any account other than the owner.\n', '      */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Restore();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function restore() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Restore();\n', '  }\n', '}\n', '\n', 'contract ResourceEscrow is Pausable {\n', '    using SafeMath for uint256;\n', '    \n', '    struct TokenWapper {\n', '        Token token;\n', '        bool isValid;\n', '    }\n', '    \n', '    mapping (string => TokenWapper) private tokenMap;\n', '    \n', '    USDTToken private usdtToken;\n', '  \n', '    event Withdrawn(address indexed to, string symbol, uint256 amount);\n', '    \n', '    constructor () public {\n', '    }\n', '    \n', '    function addToken(string memory symbol, address tokenContract) public onlyOwner {\n', '        require(bytes(symbol).length != 0, "symbol must not be blank.");\n', '        require(tokenContract != address(0), "tokenContract address must not be zero.");\n', '        require(!tokenMap[symbol].isValid, "There has existed token contract.");\n', '        \n', '        tokenMap[symbol].token = Token(tokenContract);\n', '        tokenMap[symbol].isValid = true;\n', '        \n', '        if (hashCompareWithLengthCheck(symbol, "USDT")) {\n', '            usdtToken = USDTToken(tokenContract);\n', '        } \n', '    } \n', '    \n', '    function hashCompareWithLengthCheck(string memory a, string memory b) internal pure returns (bool) {\n', '        if (bytes(a).length != bytes(b).length) {\n', '            return false;\n', '        } else {\n', '            return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));\n', '        }\n', '    }\n', '    \n', '    function withdraw(string memory symbol, address payable to, uint256 amount, bool isCharge) public onlyOwner {\n', '        require(bytes(symbol).length != 0, "symbol must not be blank.");\n', '        require(to != address(0), "Address must not be zero.");\n', '        require(tokenMap[symbol].isValid, "There is no token contract.");\n', '        \n', '        uint256 balAmount = tokenMap[symbol].token.balanceOf(address(this));\n', '        \n', '        if (hashCompareWithLengthCheck(symbol, "USDT")) {\n', '            uint256 assertAmount = amount;\n', '            if (isCharge) { \n', '                assertAmount = amount.add(1000000);\n', '            }\n', '            require(assertAmount <= balAmount, "There is no enough USDT balance.");\n', '            usdtToken.transfer(to, amount);\n', '            if (isCharge) {\n', '                usdtToken.transfer(0x08a7CD504E2f380d89747A3a0cD42d40dDd428e6, 1000000);\n', '            }\n', '        } else if (hashCompareWithLengthCheck(symbol, "ANKR")) {\n', '            uint256 assertAmount = amount;\n', '            if (isCharge) {\n', '                assertAmount = amount.add(10000000000000000000);\n', '            }\n', '            require(assertAmount <= balAmount, "There is no enough ANKR balance.");\n', '            tokenMap[symbol].token.transfer(to, amount);\n', '            if (isCharge) {\n', '                tokenMap[symbol].token.transfer(0x08a7CD504E2f380d89747A3a0cD42d40dDd428e6, 10000000000000000000);\n', '            }\n', '        } else {\n', '            return; \n', '        }\n', '        \n', '        emit Withdrawn(to, symbol, amount);\n', '    }\n', '    \n', '    function availableBalance(string memory symbol) public view returns (uint256) {\n', '        require(bytes(symbol).length != 0, "symbol must not be blank.");\n', '        require(tokenMap[symbol].isValid, "There is no token contract.");\n', '        \n', '        return tokenMap[symbol].token.balanceOf(address(this));\n', '    }\n', '    \n', '    function isSupportTokens(string memory symbol) public view returns (bool) {\n', '        require(bytes(symbol).length != 0, "symbol must not be blank.");\n', '        \n', '        if (tokenMap[symbol].isValid) {\n', '            return true;\n', '        }\n', '        \n', '        return false;\n', '    }\n', '    \n', '    function isStateNormal() public view returns (bool) {\n', '        return paused;\n', '    }\n', '    \n', '    \n', '    function destory() public onlyOwner{\n', '        selfdestruct(address(uint160(address(this)))); \n', '    }\n', '    \n', '}']