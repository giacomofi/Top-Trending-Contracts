['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', 'contract IQUASaleMint {\n', '    function mintProxyWithoutCap(address _to, uint256 _amount) public;\n', '    function mintProxy(address _to, uint256 _amount) public;\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overriden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override\n', ' * the methods to add functionality. Consider using &#39;super&#39; where appropiate to concatenate\n', ' * behavior.\n', ' */\n', 'contract QuasaCoinExchanger is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // Address where funds are collected\n', '    address public wallet;\n', '\n', '    // How many token units a buyer gets per wei\n', '    uint256 public rate;\n', '\n', '    // Quasa token sale minter\n', '    IQUASaleMint public icoSmartcontract;\n', '\n', '    function QuasaCoinExchanger() public {\n', '\n', '        owner = msg.sender;\n', '\n', '        // 1 ETH = 3000 QUA\n', '        rate = 3000;\n', '        wallet = 0x373ae730d8c4250b3d022a65ef998b8b7ab1aa53;\n', '        icoSmartcontract = IQUASaleMint(0x48299b98d25c700e8f8c4393b4ee49d525162513);\n', '    }\n', '\n', '\n', '    function setRate(uint256 _rate) onlyOwner public  {\n', '        rate = _rate;\n', '    }\n', '\n', '\n', '    // -----------------------------------------\n', '    // Crowdsale external interface\n', '    // -----------------------------------------\n', '\n', '    /**\n', '     * @dev fallback function ***DO NOT OVERRIDE***\n', '     */\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev low level token purchase ***DO NOT OVERRIDE***\n', '     * @param _beneficiary Address performing the token purchase\n', '     */\n', '    function buyTokens(address _beneficiary) public payable {\n', '\n', '        uint256 _weiAmount = msg.value;\n', '\n', '        require(_beneficiary != address(0));\n', '        require(_weiAmount != 0);\n', '\n', '        // calculate token amount to be created\n', '        uint256 _tokenAmount = _weiAmount.mul(rate);\n', '\n', '        icoSmartcontract.mintProxyWithoutCap(_beneficiary, _tokenAmount);\n', '\n', '        wallet.transfer(_weiAmount);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', 'contract IQUASaleMint {\n', '    function mintProxyWithoutCap(address _to, uint256 _amount) public;\n', '    function mintProxy(address _to, uint256 _amount) public;\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overriden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override\n', " * the methods to add functionality. Consider using 'super' where appropiate to concatenate\n", ' * behavior.\n', ' */\n', 'contract QuasaCoinExchanger is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // Address where funds are collected\n', '    address public wallet;\n', '\n', '    // How many token units a buyer gets per wei\n', '    uint256 public rate;\n', '\n', '    // Quasa token sale minter\n', '    IQUASaleMint public icoSmartcontract;\n', '\n', '    function QuasaCoinExchanger() public {\n', '\n', '        owner = msg.sender;\n', '\n', '        // 1 ETH = 3000 QUA\n', '        rate = 3000;\n', '        wallet = 0x373ae730d8c4250b3d022a65ef998b8b7ab1aa53;\n', '        icoSmartcontract = IQUASaleMint(0x48299b98d25c700e8f8c4393b4ee49d525162513);\n', '    }\n', '\n', '\n', '    function setRate(uint256 _rate) onlyOwner public  {\n', '        rate = _rate;\n', '    }\n', '\n', '\n', '    // -----------------------------------------\n', '    // Crowdsale external interface\n', '    // -----------------------------------------\n', '\n', '    /**\n', '     * @dev fallback function ***DO NOT OVERRIDE***\n', '     */\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev low level token purchase ***DO NOT OVERRIDE***\n', '     * @param _beneficiary Address performing the token purchase\n', '     */\n', '    function buyTokens(address _beneficiary) public payable {\n', '\n', '        uint256 _weiAmount = msg.value;\n', '\n', '        require(_beneficiary != address(0));\n', '        require(_weiAmount != 0);\n', '\n', '        // calculate token amount to be created\n', '        uint256 _tokenAmount = _weiAmount.mul(rate);\n', '\n', '        icoSmartcontract.mintProxyWithoutCap(_beneficiary, _tokenAmount);\n', '\n', '        wallet.transfer(_weiAmount);\n', '    }\n', '\n', '}']
