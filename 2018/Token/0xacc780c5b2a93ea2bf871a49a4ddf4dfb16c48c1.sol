['pragma solidity ^0.4.23;\n', '\n', '// File: zeppelin/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: zeppelin/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: zeppelin/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin/contracts/token/ERC20/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '// File: zeppelin/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: zeppelin/contracts/token/ERC20/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/TransferableToken.sol\n', '\n', '/**\n', '    Copyright (c) 2018 Cryptense SAS - Kryll.io\n', '\n', '    Kryll.io / Transferable ERC20 token mechanism\n', '    Version 0.2\n', '    \n', '    Permission is hereby granted, free of charge, to any person obtaining a copy\n', '    of this software and associated documentation files (the "Software"), to deal\n', '    in the Software without restriction, including without limitation the rights\n', '    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '    copies of the Software, and to permit persons to whom the Software is\n', '    furnished to do so, subject to the following conditions:\n', '\n', '    The above copyright notice and this permission notice shall be included in\n', '    all copies or substantial portions of the Software.\n', '\n', '    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN\n', '    THE SOFTWARE.\n', '\n', '    based on the contracts of OpenZeppelin:\n', '    https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts\n', '**/\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Transferable token\n', ' *\n', ' * @dev StandardToken modified with transfert on/off mechanism.\n', ' **/\n', 'contract TransferableToken is StandardToken,Ownable {\n', '\n', '    /** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\n', '    * @dev TRANSFERABLE MECANISM SECTION\n', '    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/\n', '\n', '    event Transferable();\n', '    event UnTransferable();\n', '\n', '    bool public transferable = false;\n', '    mapping (address => bool) public whitelisted;\n', '\n', '    /**\n', '        CONSTRUCTOR\n', '    **/\n', '    \n', '    constructor() \n', '        StandardToken() \n', '        Ownable()\n', '        public \n', '    {\n', '        whitelisted[msg.sender] = true;\n', '    }\n', '\n', '    /**\n', '        MODIFIERS\n', '    **/\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is not transferable.\n', '    */\n', '    modifier whenNotTransferable() {\n', '        require(!transferable);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is transferable.\n', '    */\n', '    modifier whenTransferable() {\n', '        require(transferable);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the caller can transfert token.\n', '    */\n', '    modifier canTransfert() {\n', '        if(!transferable){\n', '            require (whitelisted[msg.sender]);\n', '        } \n', '        _;\n', '   }\n', '   \n', '    /**\n', '        OWNER ONLY FUNCTIONS\n', '    **/\n', '\n', '    /**\n', '    * @dev called by the owner to allow transferts, triggers Transferable state\n', '    */\n', '    function allowTransfert() onlyOwner whenNotTransferable public {\n', '        transferable = true;\n', '        emit Transferable();\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to restrict transferts, returns to untransferable state\n', '    */\n', '    function restrictTransfert() onlyOwner whenTransferable public {\n', '        transferable = false;\n', '        emit UnTransferable();\n', '    }\n', '\n', '    /**\n', '      @dev Allows the owner to add addresse that can bypass the transfer lock.\n', '    **/\n', '    function whitelist(address _address) onlyOwner public {\n', '        require(_address != 0x0);\n', '        whitelisted[_address] = true;\n', '    }\n', '\n', '    /**\n', '      @dev Allows the owner to remove addresse that can bypass the transfer lock.\n', '    **/\n', '    function restrict(address _address) onlyOwner public {\n', '        require(_address != 0x0);\n', '        whitelisted[_address] = false;\n', '    }\n', '\n', '\n', '    /** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\n', '    * @dev Strandard transferts overloaded API\n', '    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/\n', '\n', '    function transfer(address _to, uint256 _value) public canTransfert returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public canTransfert returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '  /**\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. We recommend to use use increaseApproval\n', '   * and decreaseApproval functions instead !\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263555598\n', '   */\n', '    function approve(address _spender, uint256 _value) public canTransfert returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public canTransfert returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public canTransfert returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '// File: contracts/KryllToken.sol\n', '\n', '/**\n', '    Copyright (c) 2018 Cryptense SAS - Kryll.io\n', '\n', '    Kryll.io / KRL ERC20 Token Smart Contract    \n', '    Version 0.2\n', '\n', '    Permission is hereby granted, free of charge, to any person obtaining a copy\n', '    of this software and associated documentation files (the "Software"), to deal\n', '    in the Software without restriction, including without limitation the rights\n', '    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '    copies of the Software, and to permit persons to whom the Software is\n', '    furnished to do so, subject to the following conditions:\n', '\n', '    The above copyright notice and this permission notice shall be included in\n', '    all copies or substantial portions of the Software.\n', '\n', '    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN\n', '    THE SOFTWARE.\n', '\n', '    based on the contracts of OpenZeppelin:\n', '    https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts\n', '**/\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '\n', '\n', 'contract KryllToken is TransferableToken {\n', '//    using SafeMath for uint256;\n', '\n', '    string public symbol = "KRL";\n', '    string public name = "Kryll.io Token";\n', '    uint8 public decimals = 18;\n', '  \n', '\n', '    uint256 constant internal DECIMAL_CASES    = (10 ** uint256(decimals));\n', '    uint256 constant public   SALE             =  17737348 * DECIMAL_CASES; // Token sale\n', '    uint256 constant public   TEAM             =   8640000 * DECIMAL_CASES; // TEAM (vested)\n', '    uint256 constant public   ADVISORS         =   2880000 * DECIMAL_CASES; // Advisors\n', '    uint256 constant public   SECURITY         =   4320000 * DECIMAL_CASES; // Security Reserve\n', '    uint256 constant public   PRESS_MARKETING  =   5040000 * DECIMAL_CASES; // Press release\n', '    uint256 constant public   USER_ACQUISITION =  10080000 * DECIMAL_CASES; // User Acquisition \n', '    uint256 constant public   BOUNTY           =    720000 * DECIMAL_CASES; // Bounty (ICO & future)\n', '\n', '    address public sale_address     = 0x29e9535AF275a9010862fCDf55Fe45CD5D24C775;\n', '    address public team_address     = 0xd32E4fb9e8191A97905Fb5Be9Aa27458cD0124C1;\n', '    address public advisors_address = 0x609f5a53189cAf4EeE25709901f43D98516114Da;\n', '    address public security_address = 0x2eA5917E227552253891C1860E6c6D0057386F62;\n', '    address public press_address    = 0xE9cAad0504F3e46b0ebc347F5bf591DBcB49756a;\n', '    address public user_acq_address = 0xACD80ad0f7beBe447ea0625B606Cf3DF206DafeF;\n', '    address public bounty_address   = 0x150658D45dc62E9EB246E82e552A3ec93d664985;\n', '    bool public initialDistributionDone = false;\n', '\n', '    /**\n', '    * @dev Setup the initial distribution addresses\n', '    */\n', '    function reset(address _saleAddrss, address _teamAddrss, address _advisorsAddrss, address _securityAddrss, address _pressAddrss, address _usrAcqAddrss, address _bountyAddrss) public onlyOwner{\n', '        require(!initialDistributionDone);\n', '        team_address = _teamAddrss;\n', '        advisors_address = _advisorsAddrss;\n', '        security_address = _securityAddrss;\n', '        press_address = _pressAddrss;\n', '        user_acq_address = _usrAcqAddrss;\n', '        bounty_address = _bountyAddrss;\n', '        sale_address = _saleAddrss;\n', '    }\n', '\n', '    /**\n', '    * @dev compute & distribute the tokens\n', '    */\n', '    function distribute() public onlyOwner {\n', '        // Initialisation check\n', '        require(!initialDistributionDone);\n', '        require(sale_address != 0x0 && team_address != 0x0 && advisors_address != 0x0 && security_address != 0x0 && press_address != 0x0 && user_acq_address != 0 && bounty_address != 0x0);      \n', '\n', '        // Compute total supply \n', '        totalSupply_ = SALE.add(TEAM).add(ADVISORS).add(SECURITY).add(PRESS_MARKETING).add(USER_ACQUISITION).add(BOUNTY);\n', '\n', '        // Distribute KRL Token \n', '        balances[owner] = totalSupply_;\n', '        emit Transfer(0x0, owner, totalSupply_);\n', '\n', '        transfer(team_address, TEAM);\n', '        transfer(advisors_address, ADVISORS);\n', '        transfer(security_address, SECURITY);\n', '        transfer(press_address, PRESS_MARKETING);\n', '        transfer(user_acq_address, USER_ACQUISITION);\n', '        transfer(bounty_address, BOUNTY);\n', '        transfer(sale_address, SALE);\n', '        initialDistributionDone = true;\n', '        whitelist(sale_address); // Auto whitelist sale address\n', '        whitelist(team_address); // Auto whitelist team address (vesting transfert)\n', '    }\n', '\n', '    /**\n', '    * @dev Allows owner to later update token name if needed.\n', '    */\n', '    function setName(string _name) onlyOwner public {\n', '        name = _name;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/KryllVesting.sol\n', '\n', '/**\n', '    Copyright (c) 2018 Cryptense SAS - Kryll.io\n', '\n', '    Kryll.io / KRL Vesting Smart Contract\n', '    Version 0.2\n', '    \n', '    Permission is hereby granted, free of charge, to any person obtaining a copy\n', '    of this software and associated documentation files (the "Software"), to deal\n', '    in the Software without restriction, including without limitation the rights\n', '    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '    copies of the Software, and to permit persons to whom the Software is\n', '    furnished to do so, subject to the following conditions:\n', '\n', '    The above copyright notice and this permission notice shall be included in\n', '    all copies or substantial portions of the Software.\n', '\n', '    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN\n', '    THE SOFTWARE.\n', '\n', '    based on the contracts of OpenZeppelin:\n', '    https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts\n', '**/\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title KryllVesting\n', ' * @dev A token holder contract that can release its token balance gradually like a\n', ' * typical vesting scheme, with a cliff and vesting period.\n', ' */\n', 'contract KryllVesting is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    event Released(uint256 amount);\n', '\n', '    // beneficiary of tokens after they are released\n', '    address public beneficiary;\n', '    KryllToken public token;\n', '\n', '    uint256 public startTime;\n', '    uint256 public cliff;\n', '    uint256 public released;\n', '\n', '\n', '    uint256 constant public   VESTING_DURATION    =  31536000; // 1 Year in second\n', '    uint256 constant public   CLIFF_DURATION      =   7776000; // 3 months (90 days) in second\n', '\n', '\n', '    /**\n', '    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '    * _beneficiary, gradually in a linear fashion. By then all of the balance will have vested.\n', '    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '    * @param _token The token to be vested\n', '    */\n', '    function setup(address _beneficiary,address _token) public onlyOwner{\n', '        require(startTime == 0); // Vesting not started\n', '        require(_beneficiary != address(0));\n', '        // Basic init\n', '        changeBeneficiary(_beneficiary);\n', '        token = KryllToken(_token);\n', '    }\n', '\n', '    /**\n', '    * @notice Start the vesting process.\n', '    */\n', '    function start() public onlyOwner{\n', '        require(token != address(0));\n', '        require(startTime == 0); // Vesting not started\n', '        startTime = now;\n', '        cliff = startTime.add(CLIFF_DURATION);\n', '    }\n', '\n', '    /**\n', '    * @notice Is vesting started flag.\n', '    */\n', '    function isStarted() public view returns (bool) {\n', '        return (startTime > 0);\n', '    }\n', '\n', '\n', '    /**\n', '    * @notice Owner can change beneficiary address\n', '    */\n', '    function changeBeneficiary(address _beneficiary) public onlyOwner{\n', '        beneficiary = _beneficiary;\n', '    }\n', '\n', '\n', '    /**\n', '    * @notice Transfers vested tokens to beneficiary.\n', '    */\n', '    function release() public {\n', '        require(startTime != 0);\n', '        require(beneficiary != address(0));\n', '        \n', '        uint256 unreleased = releasableAmount();\n', '        require(unreleased > 0);\n', '\n', '        released = released.add(unreleased);\n', '        token.transfer(beneficiary, unreleased);\n', '        emit Released(unreleased);\n', '    }\n', '\n', '    /**\n', "    * @dev Calculates the amount that has already vested but hasn't been released yet.\n", '    */\n', '    function releasableAmount() public view returns (uint256) {\n', '        return vestedAmount().sub(released);\n', '    }\n', '\n', '    /**\n', '    * @dev Calculates the amount that has already vested.\n', '    */\n', '    function vestedAmount() public view returns (uint256) {\n', '        uint256 currentBalance = token.balanceOf(this);\n', '        uint256 totalBalance = currentBalance.add(released);\n', '\n', '        if (now < cliff) {\n', '            return 0;\n', '        } else if (now >= startTime.add(VESTING_DURATION)) {\n', '            return totalBalance;\n', '        } else {\n', '            return totalBalance.mul(now.sub(startTime)).div(VESTING_DURATION);\n', '        }\n', '    }\n', '}']