['pragma solidity 0.4.23;\n', '\n', '// File: contracts/ACOTokenCrowdsale.sol\n', '\n', 'interface ACOTokenCrowdsale {\n', '    function buyTokens(address beneficiary) external payable;\n', '    function hasEnded() external view returns (bool);\n', '}\n', '\n', '// File: contracts/lib/DS-Math.sol\n', '\n', '/// math.sol -- mixin for inline numerical wizardry\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.4.23;\n', '\n', 'contract DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x);\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x);\n', '    }\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x);\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    // function max(uint x, uint y) internal pure returns (uint z) {\n', '    //     return x >= y ? x : y;\n', '    // }\n', '    // function imin(int x, int y) internal pure returns (int z) {\n', '    //     return x <= y ? x : y;\n', '    // }\n', '    // function imax(int x, int y) internal pure returns (int z) {\n', '    //     return x >= y ? x : y;\n', '    // }\n', '\n', '    // uint constant WAD = 10 ** 18;\n', '    // uint constant RAY = 10 ** 27;\n', '\n', '    // function wmul(uint x, uint y) internal pure returns (uint z) {\n', '    //     z = add(mul(x, y), WAD / 2) / WAD;\n', '    // }\n', '    // function rmul(uint x, uint y) internal pure returns (uint z) {\n', '    //     z = add(mul(x, y), RAY / 2) / RAY;\n', '    // }\n', '    // function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '    //     z = add(mul(x, WAD), y / 2) / y;\n', '    // }\n', '    // function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '    //     z = add(mul(x, RAY), y / 2) / y;\n', '    // }\n', '\n', '    // // This famous algorithm is called "exponentiation by squaring"\n', '    // // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    // //\n', "    // // It's O(log n), instead of O(n) for naive repeated multiplication.\n", '    // //\n', '    // // These facts are why it works:\n', '    // //\n', '    // //  If n is even, then x^n = (x^2)^(n/2).\n', '    // //  If n is odd,  then x^n = x * x^(n-1),\n', '    // //   and applying the equation for even x gives\n', '    // //    x^n = x * (x^2)^((n-1) / 2).\n', '    // //\n', '    // //  Also, EVM division is flooring and\n', '    // //    floor[(n-1) / 2] = floor[n / 2].\n', '    // //\n', '    // function rpow(uint x, uint n) internal pure returns (uint z) {\n', '    //     z = n % 2 != 0 ? x : RAY;\n', '\n', '    //     for (n /= 2; n != 0; n /= 2) {\n', '    //         x = rmul(x, x);\n', '\n', '    //         if (n % 2 != 0) {\n', '    //             z = rmul(z, x);\n', '    //         }\n', '    //     }\n', '    // }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/TokenDestructible.sol\n', '\n', '/**\n', ' * @title TokenDestructible:\n', ' * @author Remco Bloemen <remco@2π.com>\n', ' * @dev Base contract that can be destroyed by owner. All funds in contract including\n', ' * listed tokens will be sent to the owner.\n', ' */\n', 'contract TokenDestructible is Ownable {\n', '\n', '  constructor() public payable { }\n', '\n', '  /**\n', '   * @notice Terminate contract and refund to owner\n', '   * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to\n', '   refund.\n', '   * @notice The called token contracts could try to re-enter this contract. Only\n', '   supply token contracts you trust.\n', '   */\n', '  function destroy(address[] tokens) onlyOwner public {\n', '\n', '    // Transfer tokens to owner\n', '    for (uint256 i = 0; i < tokens.length; i++) {\n', '      ERC20Basic token = ERC20Basic(tokens[i]);\n', '      uint256 balance = token.balanceOf(this);\n', '      token.transfer(owner, balance);\n', '    }\n', '\n', '    // Transfer Eth to owner and terminate contract\n', '    selfdestruct(owner);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Claimable.sol\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    require(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    require(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    require(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '// File: contracts/TokenBuy.sol\n', '\n', '/// @title Group-buy contract for Token ICO\n', '/// @author Joe Wasson\n', '/// @notice Allows for group purchase of the Token ICO. This is done\n', '///   in two phases:\n', '///     a) contributions initiate a purchase on demand.\n', '///     b) tokens are collected when they are unfrozen\n', 'contract TokenBuy is Pausable, Claimable, TokenDestructible, DSMath {\n', '    using SafeERC20 for ERC20Basic;\n', '\n', '    /// @notice Token ICO contract\n', '    ACOTokenCrowdsale public crowdsaleContract;\n', '\n', '    /// @notice Token contract\n', '    ERC20Basic public tokenContract;\n', '\n', '    /// @notice Map of contributors and their token balances\n', '    mapping(address => uint) public balances;\n', '\n', '    /// @notice List of contributors to the sale\n', '    address[] public contributors;\n', '\n', '    /// @notice Total amount contributed to the sale\n', '    uint public totalContributions;\n', '\n', '    /// @notice Total number of tokens purchased\n', '    uint public totalTokensPurchased;\n', '\n', '    /// @notice Emitted whenever a contribution is made\n', '    event Purchase(address indexed sender, uint ethAmount, uint tokensPurchased);\n', '\n', '    /// @notice Emitted whenever tokens are collected fromthe contract\n', '    event Collection(address indexed recipient, uint amount);\n', '\n', '    /// @notice Time when locked funds in the contract can be retrieved.\n', '    uint constant unlockTime = 1543622400; // 2018-12-01 00:00:00 GMT\n', '\n', '    /// @notice Guards against executing the function if the sale\n', '    ///    is not running.\n', '    modifier whenSaleRunning() {\n', '        require(!crowdsaleContract.hasEnded());\n', '        _;\n', '    }\n', '\n', '    /// @param crowdsale the Crowdsale contract (or a wrapper around it)\n', '    /// @param token the token contract\n', '    constructor(ACOTokenCrowdsale crowdsale, ERC20Basic token) public {\n', '        require(crowdsale != address(0x0));\n', '        require(token != address(0x0));\n', '        crowdsaleContract = crowdsale;\n', '        tokenContract = token;\n', '    }\n', '\n', '    /// @notice returns the number of contributors in the list of contributors\n', '    /// @return count of contributors\n', '    /// @dev As the `collectAll` function is called the contributor array is cleaned up\n', '    ///     consequently this method only returns the remaining contributor count.\n', '    function contributorCount() public view returns (uint) {\n', '        return contributors.length;\n', '    }\n', '\n', '    /// @dev Dispatches between buying and collecting\n', '    function() public payable {\n', '        if (msg.value == 0) {\n', '            collectFor(msg.sender);\n', '        } else {\n', '            buy();\n', '        }\n', '    }\n', '\n', '    /// @notice Executes a purchase.\n', '    function buy() whenNotPaused whenSaleRunning private {\n', '        address buyer = msg.sender;\n', '        totalContributions += msg.value;\n', '        uint tokensPurchased = purchaseTokens();\n', '        totalTokensPurchased = add(totalTokensPurchased, tokensPurchased);\n', '\n', '        uint previousBalance = balances[buyer];\n', '        balances[buyer] = add(previousBalance, tokensPurchased);\n', '\n', '        // new contributor\n', '        if (previousBalance == 0) {\n', '            contributors.push(buyer);\n', '        }\n', '\n', '        emit Purchase(buyer, msg.value, tokensPurchased);\n', '    }\n', '\n', '    function purchaseTokens() private returns (uint tokensPurchased) {\n', '        address me = address(this);\n', '        uint previousBalance = tokenContract.balanceOf(me);\n', '        crowdsaleContract.buyTokens.value(msg.value)(me);\n', '        uint newBalance = tokenContract.balanceOf(me);\n', '\n', '        require(newBalance > previousBalance); // Fail on underflow or purchase of 0\n', '        return newBalance - previousBalance;\n', '    }\n', '\n', '    /// @notice Allows users to collect purchased tokens after the sale.\n', '    /// @param recipient the address to collect tokens for\n', "    /// @dev Here we don't transfer zero tokens but this is an arbitrary decision.\n", '    function collectFor(address recipient) private {\n', '        uint tokensOwned = balances[recipient];\n', '        if (tokensOwned == 0) return;\n', '\n', '        delete balances[recipient];\n', '        tokenContract.safeTransfer(recipient, tokensOwned);\n', '        emit Collection(recipient, tokensOwned);\n', '    }\n', '\n', '    /// @notice Collects the balances for members of the purchase\n', '    /// @param max the maximum number of members to process (for gas purposes)\n', '    function collectAll(uint8 max) public returns (uint8 collected) {\n', '        max = uint8(min(max, contributors.length));\n', '        require(max > 0, "can\'t collect for zero users");\n', '\n', '        uint index = contributors.length - 1;\n', '        for(uint offset = 0; offset < max; ++offset) {\n', '            address recipient = contributors[index - offset];\n', '\n', '            if (balances[recipient] > 0) {\n', '                collected++;\n', '                collectFor(recipient);\n', '            }\n', '        }\n', '\n', '        contributors.length -= offset;\n', '    }\n', '\n', '    /// @notice Shuts down the contract\n', '    function destroy(address[] tokens) onlyOwner public {\n', '        require(now > unlockTime || (contributorCount() == 0 && paused));\n', '\n', '        super.destroy(tokens);\n', '    }\n', '}']