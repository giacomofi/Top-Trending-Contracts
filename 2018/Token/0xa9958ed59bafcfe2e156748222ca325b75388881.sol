['pragma solidity ^0.4.21;\n', '/**\n', ' * Changes by https://www.docademic.com/\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\tfunction mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 c = a * b;\n', '\t\tassert(c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\t\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\t// assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\t\tuint256 c = a / b;\n', '\t\t// assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\t\treturn c;\n', '\t}\n', '\t\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tassert(b <= a);\n', '\t\treturn a - b;\n', '\t}\n', '\t\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\tassert(c >= a);\n', '\t\treturn c;\n', '\t}\n', '}\n', '\n', '/**\n', ' * Changes by https://www.docademic.com/\n', ' */\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\taddress public owner;\n', '\t\n', '\tevent OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\t\n', '\t/**\n', '\t * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '\t * account.\n', '\t */\n', '\tfunction Ownable() public {\n', '\t\towner = msg.sender;\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Throws if called by any account other than the owner.\n', '\t */\n', '\tmodifier onlyOwner() {\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '\t * @param _newOwner The address to transfer ownership to.\n', '\t */\n', '\tfunction transferOwnership(address _newOwner) public onlyOwner {\n', '\t\trequire(_newOwner != address(0));\n', '\t\temit OwnershipTransferred(owner, _newOwner);\n', '\t\towner = _newOwner;\n', '\t}\n', '}\n', '\n', 'contract Destroyable is Ownable {\n', '\t/**\n', '\t * @notice Allows to destroy the contract and return the tokens to the owner.\n', '\t */\n', '\tfunction destroy() public onlyOwner {\n', '\t\tselfdestruct(owner);\n', '\t}\n', '}\n', '\n', 'interface Token {\n', '\tfunction balanceOf(address who) view external returns (uint256);\n', '\t\n', '\tfunction allowance(address _owner, address _spender) view external returns (uint256);\n', '\t\n', '\tfunction transfer(address _to, uint256 _value) external returns (bool);\n', '\t\n', '\tfunction approve(address _spender, uint256 _value) external returns (bool);\n', '\t\n', '\tfunction increaseApproval(address _spender, uint256 _addedValue) external returns (bool);\n', '\t\n', '\tfunction decreaseApproval(address _spender, uint256 _subtractedValue) external returns (bool);\n', '}\n', '\n', 'contract TokenPool is Ownable, Destroyable {\n', '\tusing SafeMath for uint256;\n', '\t\n', '\tToken public token;\n', '\taddress public spender;\n', '\t\n', '\tevent AllowanceChanged(uint256 _previousAllowance, uint256 _allowed);\n', '\tevent SpenderChanged(address _previousSpender, address _spender);\n', '\t\n', '\t\n', '\t/**\n', '\t * @dev Constructor.\n', '\t * @param _token The token address\n', '\t * @param _spender The spender address\n', '\t */\n', '\tfunction TokenPool(address _token, address _spender) public{\n', '\t\trequire(_token != address(0) && _spender != address(0));\n', '\t\ttoken = Token(_token);\n', '\t\tspender = _spender;\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Get the token balance of the contract.\n', '\t * @return _balance The token balance of this contract in wei\n', '\t */\n', '\tfunction Balance() view public returns (uint256 _balance) {\n', '\t\treturn token.balanceOf(address(this));\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Get the token allowance of the contract to the spender.\n', '\t * @return _balance The token allowed to the spender in wei\n', '\t */\n', '\tfunction Allowance() view public returns (uint256 _balance) {\n', '\t\treturn token.allowance(address(this), spender);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Allows the owner to set up the allowance to the spender.\n', '\t */\n', '\tfunction setUpAllowance() public onlyOwner {\n', '\t\temit AllowanceChanged(token.allowance(address(this), spender), token.balanceOf(address(this)));\n', '\t\ttoken.approve(spender, token.balanceOf(address(this)));\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Allows the owner to update the allowance of the spender.\n', '\t */\n', '\tfunction updateAllowance() public onlyOwner {\n', '\t\tuint256 balance = token.balanceOf(address(this));\n', '\t\tuint256 allowance = token.allowance(address(this), spender);\n', '\t\tuint256 difference = balance.sub(allowance);\n', '\t\ttoken.increaseApproval(spender, difference);\n', '\t\temit AllowanceChanged(allowance, allowance.add(difference));\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Allows the owner to destroy the contract and return the tokens to the owner.\n', '\t */\n', '\tfunction destroy() public onlyOwner {\n', '\t\ttoken.transfer(owner, token.balanceOf(address(this)));\n', '\t\tselfdestruct(owner);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Allows the owner to change the spender.\n', '\t * @param _spender The new spender address\n', '\t */\n', '\tfunction changeSpender(address _spender) public onlyOwner {\n', '\t\trequire(_spender != address(0));\n', '\t\temit SpenderChanged(spender, _spender);\n', '\t\ttoken.approve(spender, 0);\n', '\t\tspender = _spender;\n', '\t\tsetUpAllowance();\n', '\t}\n', '\t\n', '}']
['pragma solidity ^0.4.21;\n', '/**\n', ' * Changes by https://www.docademic.com/\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\tfunction mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 c = a * b;\n', '\t\tassert(c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\t\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\t// assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\t\tuint256 c = a / b;\n', "\t\t// assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\t\treturn c;\n', '\t}\n', '\t\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tassert(b <= a);\n', '\t\treturn a - b;\n', '\t}\n', '\t\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\tassert(c >= a);\n', '\t\treturn c;\n', '\t}\n', '}\n', '\n', '/**\n', ' * Changes by https://www.docademic.com/\n', ' */\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\taddress public owner;\n', '\t\n', '\tevent OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\t\n', '\t/**\n', '\t * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '\t * account.\n', '\t */\n', '\tfunction Ownable() public {\n', '\t\towner = msg.sender;\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Throws if called by any account other than the owner.\n', '\t */\n', '\tmodifier onlyOwner() {\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '\t * @param _newOwner The address to transfer ownership to.\n', '\t */\n', '\tfunction transferOwnership(address _newOwner) public onlyOwner {\n', '\t\trequire(_newOwner != address(0));\n', '\t\temit OwnershipTransferred(owner, _newOwner);\n', '\t\towner = _newOwner;\n', '\t}\n', '}\n', '\n', 'contract Destroyable is Ownable {\n', '\t/**\n', '\t * @notice Allows to destroy the contract and return the tokens to the owner.\n', '\t */\n', '\tfunction destroy() public onlyOwner {\n', '\t\tselfdestruct(owner);\n', '\t}\n', '}\n', '\n', 'interface Token {\n', '\tfunction balanceOf(address who) view external returns (uint256);\n', '\t\n', '\tfunction allowance(address _owner, address _spender) view external returns (uint256);\n', '\t\n', '\tfunction transfer(address _to, uint256 _value) external returns (bool);\n', '\t\n', '\tfunction approve(address _spender, uint256 _value) external returns (bool);\n', '\t\n', '\tfunction increaseApproval(address _spender, uint256 _addedValue) external returns (bool);\n', '\t\n', '\tfunction decreaseApproval(address _spender, uint256 _subtractedValue) external returns (bool);\n', '}\n', '\n', 'contract TokenPool is Ownable, Destroyable {\n', '\tusing SafeMath for uint256;\n', '\t\n', '\tToken public token;\n', '\taddress public spender;\n', '\t\n', '\tevent AllowanceChanged(uint256 _previousAllowance, uint256 _allowed);\n', '\tevent SpenderChanged(address _previousSpender, address _spender);\n', '\t\n', '\t\n', '\t/**\n', '\t * @dev Constructor.\n', '\t * @param _token The token address\n', '\t * @param _spender The spender address\n', '\t */\n', '\tfunction TokenPool(address _token, address _spender) public{\n', '\t\trequire(_token != address(0) && _spender != address(0));\n', '\t\ttoken = Token(_token);\n', '\t\tspender = _spender;\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Get the token balance of the contract.\n', '\t * @return _balance The token balance of this contract in wei\n', '\t */\n', '\tfunction Balance() view public returns (uint256 _balance) {\n', '\t\treturn token.balanceOf(address(this));\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Get the token allowance of the contract to the spender.\n', '\t * @return _balance The token allowed to the spender in wei\n', '\t */\n', '\tfunction Allowance() view public returns (uint256 _balance) {\n', '\t\treturn token.allowance(address(this), spender);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Allows the owner to set up the allowance to the spender.\n', '\t */\n', '\tfunction setUpAllowance() public onlyOwner {\n', '\t\temit AllowanceChanged(token.allowance(address(this), spender), token.balanceOf(address(this)));\n', '\t\ttoken.approve(spender, token.balanceOf(address(this)));\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Allows the owner to update the allowance of the spender.\n', '\t */\n', '\tfunction updateAllowance() public onlyOwner {\n', '\t\tuint256 balance = token.balanceOf(address(this));\n', '\t\tuint256 allowance = token.allowance(address(this), spender);\n', '\t\tuint256 difference = balance.sub(allowance);\n', '\t\ttoken.increaseApproval(spender, difference);\n', '\t\temit AllowanceChanged(allowance, allowance.add(difference));\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Allows the owner to destroy the contract and return the tokens to the owner.\n', '\t */\n', '\tfunction destroy() public onlyOwner {\n', '\t\ttoken.transfer(owner, token.balanceOf(address(this)));\n', '\t\tselfdestruct(owner);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Allows the owner to change the spender.\n', '\t * @param _spender The new spender address\n', '\t */\n', '\tfunction changeSpender(address _spender) public onlyOwner {\n', '\t\trequire(_spender != address(0));\n', '\t\temit SpenderChanged(spender, _spender);\n', '\t\ttoken.approve(spender, 0);\n', '\t\tspender = _spender;\n', '\t\tsetUpAllowance();\n', '\t}\n', '\t\n', '}']
