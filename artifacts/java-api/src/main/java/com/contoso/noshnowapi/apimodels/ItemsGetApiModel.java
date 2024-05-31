package com.contoso.noshnowapi.apimodels;

import java.util.List;

public class ItemsGetApiModel {
    private List<Long> itemKeys;

    public List<Long> getItemKeys() {
        return itemKeys;
    }

    public void setItemKeys(List<Long> itemKeys) {
        this.itemKeys = itemKeys;
    }
}
