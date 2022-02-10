['pragma solidity 0.5.7;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value)\n', '        external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '        external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender)\n', '        external view returns (uint256);\n', '\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/* Copyright (C) 2017 NexusMutual.io\n', '\n', '  This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '\n', '  This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '\n', '  You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see http://www.gnu.org/licenses/ */\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract NXMToken is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    event WhiteListed(address indexed member);\n', '\n', '    event BlackListed(address indexed member);\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '    mapping (address => bool) public whiteListed;\n', '\n', '    mapping(address => uint) public isLockedForMV;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    string public name = "NXM";\n', '    string public symbol = "NXM";\n', '    uint8 public decimals = 18;\n', '    address public operator;\n', '\n', '    modifier canTransfer(address _to) {\n', '        require(whiteListed[_to]);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        if (operator != address(0))\n', '            require(msg.sender == operator);\n', '        _;\n', '    }\n', '\n', '    constructor(address _founderAddress, uint _initialSupply) public {\n', '        _mint(_founderAddress, _initialSupply);\n', '    }\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param owner The address to query the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param owner address The address which owns the funds.\n', '    * @param spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(\n', '        address owner,\n', '        address spender\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param spender The address which will spend the funds.\n', '    * @param value The amount of tokens to be spent.\n', '    */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed_[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param spender The address which will spend the funds.\n', '    * @param addedValue The amount of tokens to increase the allowance by.\n', '    */\n', '    function increaseAllowance(\n', '        address spender,\n', '        uint256 addedValue\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = (\n', '        _allowed[msg.sender][spender].add(addedValue));\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed_[_spender] == 0. To decrement\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param spender The address which will spend the funds.\n', '    * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '    */\n', '    function decreaseAllowance(\n', '        address spender,\n', '        uint256 subtractedValue\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = (\n', '        _allowed[msg.sender][spender].sub(subtractedValue));\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds a user to whitelist\n', '    * @param _member address to add to whitelist\n', '    */\n', '    function addToWhiteList(address _member) public onlyOperator returns (bool) {\n', '        whiteListed[_member] = true;\n', '        emit WhiteListed(_member);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev removes a user from whitelist\n', '    * @param _member address to remove from whitelist\n', '    */\n', '    function removeFromWhiteList(address _member) public onlyOperator returns (bool) {\n', '        whiteListed[_member] = false;\n', '        emit BlackListed(_member);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev change operator address \n', '    * @param _newOperator address of new operator\n', '    */\n', '    function changeOperator(address _newOperator) public onlyOperator returns (bool) {\n', '        operator = _newOperator;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev burns an amount of the tokens of the message sender\n', '    * account.\n', '    * @param amount The amount that will be burnt.\n', '    */\n', '    function burn(uint256 amount) public returns (bool) {\n', '        _burn(msg.sender, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '    * @param from address The address which you want to send tokens from\n', '    * @param value uint256 The amount of token to be burned\n', '    */\n', '    function burnFrom(address from, uint256 value) public returns (bool) {\n', '        _burnFrom(from, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev function that mints an amount of the token and assigns it to\n', '    * an account.\n', '    * @param account The account that will receive the created tokens.\n', '    * @param amount The amount that will be created.\n', '    */\n', '    function mint(address account, uint256 amount) public onlyOperator {\n', '        _mint(account, amount);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function transfer(address to, uint256 value) public canTransfer(to) returns (bool) {\n', '\n', '        require(isLockedForMV[msg.sender] < now); // if not voted under governance\n', '        require(value <= _balances[msg.sender]);\n', '        _transfer(to, value); \n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens to the operator from the specified address\n', '    * @param from The address to transfer from.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function operatorTransfer(address from, uint256 value) public onlyOperator returns (bool) {\n', '        require(value <= _balances[from]);\n', '        _transferFrom(from, operator, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param from address The address which you want to send tokens from\n', '    * @param to address The address which you want to transfer to\n', '    * @param value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    )\n', '        public\n', '        canTransfer(to)\n', '        returns (bool)\n', '    {\n', '        require(isLockedForMV[from] < now); // if not voted under governance\n', '        require(value <= _balances[from]);\n', '        require(value <= _allowed[from][msg.sender]);\n', '        _transferFrom(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', "     * @dev Lock the user's tokens \n", "     * @param _of user's address.\n", '     */\n', '    function lockForMemberVote(address _of, uint _days) public onlyOperator {\n', '        if (_days.add(now) > isLockedForMV[_of])\n', '            isLockedForMV[_of] = _days.add(now);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function _transfer(address to, uint256 value) internal {\n', '        _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(msg.sender, to, value);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param from address The address which you want to send tokens from\n', '    * @param to address The address which you want to transfer to\n', '    * @param value uint256 the amount of tokens to be transferred\n', '    */\n', '    function _transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    )\n', '        internal\n', '    {\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '    * @dev Internal function that mints an amount of the token and assigns it to\n', '    * an account. This encapsulates the modification of balances such that the\n', '    * proper events are emitted.\n', '    * @param account The account that will receive the created tokens.\n', '    * @param amount The amount that will be created.\n', '    */\n', '    function _mint(address account, uint256 amount) internal {\n', '        require(account != address(0));\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    /**\n', '    * @dev Internal function that burns an amount of the token of a given\n', '    * account.\n', '    * @param account The account whose tokens will be burnt.\n', '    * @param amount The amount that will be burnt.\n', '    */\n', '    function _burn(address account, uint256 amount) internal {\n', '        require(amount <= _balances[account]);\n', '\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _balances[account] = _balances[account].sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    /**\n', '    * @dev Internal function that burns an amount of the token of a given\n', "    * account, deducting from the sender's allowance for said account. Uses the\n", '    * internal burn function.\n', '    * @param account The account whose tokens will be burnt.\n', '    * @param value The amount that will be burnt.\n', '    */\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        require(value <= _allowed[account][msg.sender]);\n', '\n', '        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '        // this function needs to emit an event with the updated approval.\n', '        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(\n', '        value);\n', '        _burn(account, value);\n', '    }\n', '}']