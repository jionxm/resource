package com.tedu.plugin.workflow;

import com.tedu.base.common.page.QueryPage;
import com.tedu.base.engine.service.FormService;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author yangjixin
 * @Description: TODO
 * @date 2018/4/4
 */
@Component
public class FormSDK {

    @Resource
    FormService formService;

    /**
     * 通用分页查询
     *
     * @param sqlId
     * @param pageIndex
     * @param pageSize
     *
     * @return
     */
    public Map <String, Object> formDealQuery(String sqlId, Map <String, String> condition, Integer pageIndex, Integer pageSize) {
        Map <String, Object> result = new HashMap <String, Object>(3);
        QueryPage queryPage = new QueryPage();
        queryPage.setQueryParam(sqlId);
        if (condition != null && !condition.isEmpty()) {
            for (String key : condition.keySet()) {
                queryPage.getData().put(key, condition.get(key));
            }
        }
        queryPage.setPage(pageIndex);
        if (pageSize == null) {
            pageSize = PageInfo.PAGE_SIZE;
        }
        queryPage.setRows(pageSize);
        queryPage.setPage(pageIndex);

        List <Map <String, Object>> list = formService.queryBySqlId(queryPage);
        result.put("list", list);
        result.put("totalPage", queryPage.getTotalPage());
        result.put("totalRecord", queryPage.getTotalRecord());
        return result;
    }

}
