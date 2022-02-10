['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-22\n', '*/\n', '\n', '// {VERSION 6 0 "IBM INTEL NT" "6.0" }\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'interface IBorrower {\n', '    function executeOnFlashMint(uint256 amount) external;\n', '}\n', '\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', '\n', '\n', '        return c;\n', '    }\n', '\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '\n', '    function transfer(address recipient, uint256 amount) public returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));\n', '        return true;\n', '    }\n', '\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount);\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '\n', '    function _mint(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '\n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        _burn(account, amount);\n', '        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));\n', '    }\n', '}\n', '\n', '// File: browser/FlashETH.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', '\n', '\n', 'contract PigPig is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "Brand Stuff";\n', '    string public symbol = "PIG";\n', '    uint8 public decimals = 18;\n', '\n', '    function() external payable {\n', '        _mint(msg.sender, msg.value);\n', '    }\n', '\n', '\n', '    function deposit() public payable {\n', '        _mint(msg.sender, msg.value);\n', '    }\n', '\n', '\n', '    function withdraw(uint256 amount) public {\n', '        _burn(msg.sender, amount);\n', '        msg.sender.transfer(amount);\n', '    }\n', '\n', '\n', '    modifier flashMint(uint256 amount) {\n', '\n', '        _mint(msg.sender, amount); \n', '\n', '\n', '        _;\n', '\n', '        // burn tokens\n', '        _burn(msg.sender, amount); \n', '\n', '\n', '        require(\n', '            address(this).balance >= totalSupply(),\n', '            "redeemability was broken"\n', '        );\n', '    }\n', '\n', '\n', '    function softFlashFuck(uint256 amount) public flashMint(amount) {\n', '\n', '        IBorrower(msg.sender).executeOnFlashMint(amount);\n', '    }\n', '\n', '\n', '    function hardFlashFuck(\n', '        address target,\n', '        bytes memory targetCalldata,\n', '        uint256 amount\n', '    ) public flashMint(amount) {\n', '        (bool success, ) = target.call(targetCalldata);\n', '        require(success, "external call failed");\n', '    }\n', '}']