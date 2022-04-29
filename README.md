## simple-myerc20-contract
**Methods**
* `totalSupply()`
    * Returns the total supply of the token, must be provided while deploying as constructor argument.
* `balanceOf(address)`
    * Returns the balance of the given address.
* `mint(address, uint256)`
    * Mints the given amount of tokens to the given address, must be called by contract owner address.
* `burn(uint256)`
    * Burns the given amount of tokens from caller(msg.sender) address.
* `transfer(address, uint256)`
    * Transfers the given amount of tokens to the given address from caller address.
* `transferFrom(address, address, uint256)`
    * Transfers the given amount of tokens from the sender address to the receiver address but the caller is other authorized address(must be approve with certain amount of tokens).
* `approve(address, uint256)`
    * Give permission to other address to make transfer on behalf of the owner with predefined amount.
* `allowance(address, address)`
    * Returns the total remaining amount of tokens that the owner allowed to the spender address.

**Events**
* `Minted(address, uint256)`
    * Emitted when the tokens is minted.
* `Burnt(address, uint256)`
    * Emitted when the tokens is burnt.
* `Transfer(address, address, uint256)`
    * Emitted when the tokens is transferred.
* `Approval(address, address, uint256)` 
    * Emitted when the tokens is approved to certain address.  