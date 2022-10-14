// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Base.sol";
import "@thirdweb-dev/contracts/base/ERC721Drop.sol";

contract Contract is ERC721Drop {
    uint256 public maxSupply;
    uint256 public cost;
    string public baseURI;
    string public baseExtension = ".json";

    bool public revealed = true;

    // 0 for Pause
    // 1 for Public
    bool public pause = true;

    /// @notice emitted when a new marketplace is approved or unapproved
    event MarketplaceApproved(address indexed marketplace, bool approved);

    /// @notice Mapping of approved marketplaces
    mapping(address => bool) public approvedMarketplaces;

    constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps,
        address _primaryRecepient
    )
        ERC721Drop(
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps,
            _primaryRecepient
        )
    {}

    function toggleContractPause() public onlyOwner {
        pause = true;
    }

    function toggleContractStart() public onlyOwner {
        pause = false;
    }

    function setCost(uint256 _price) public onlyOwner {
        cost = _price;
    }

    function setMaxSupply(uint256 _supply) public onlyOwner {
        maxSupply = _supply;
    }

        /**
     * @notice Approve or disapprove a marketplace contract to enable or disable trading on it
     */
    function setApprovedMarketplace(address market, bool approved) public onlyOwner {
        approvedMarketplaces[market] = approved;
        emit MarketplaceApproved(market, approved);
    }

    function approve(address to, uint256 tokenId) public override {
        require(approvedMarketplaces[to], "Marketplace not approved by contract owner");
        super.approve(to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public override {
        require(approvedMarketplaces[operator], "Marketplace not approved by contract owner");
        super.setApprovalForAll(operator, approved);
    }
}
