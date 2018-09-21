/*
 * Tmooc 3.0
 *
 * Copyright © 2018 Tarena Technology Group Ltd. All rights reserved..
 */
package com.tedu.base.ftl.controller;

import java.io.Serializable;

/**
 * <p>
 * Description:
 * </p>
 *
 * @author Wanghc
 * @version 1.0

 * <p>
 * History:
 * -----------------------------------------------
 * Date: 2018年8月28日 下午2:51:28
 * Author: Wanghc
 * Version: 1.0
 * OP: Create
 * -----------------------------------------------
 * </p>
 *
 * @since
 * @see
 */
public class CourseDo implements Serializable {

    /**
     *
     */
    private static final long serialVersionUID = 8975659869447368364L;
    /** 课程ID*/
    private Long courseId;
    /** 课程名称*/
    private String courseName;
    /** 版本ID*/
    private Long versionId;
    /** 版本名称*/
    private String versionName;
    /** 大阶段ID*/
    private Long stageId;
    /** 大阶段名称*/
    private String stageName;

    /**
     * @return the courseId
     */
    public Long getCourseId() {
        return courseId;
    }

    /**
     * @param courseId the courseId to set
     */
    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    /**
     * @return the courseName
     */
    public String getCourseName() {
        return courseName;
    }

    /**
     * @param courseName the courseName to set
     */
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    /**
     * @return the versionId
     */
    public Long getVersionId() {
        return versionId;
    }

    /**
     * @param versionId the versionId to set
     */
    public void setVersionId(Long versionId) {
        this.versionId = versionId;
    }

    /**
     * @return the versionName
     */
    public String getVersionName() {
        return versionName;
    }

    /**
     * @param versionName the versionName to set
     */
    public void setVersionName(String versionName) {
        this.versionName = versionName;
    }

    /**
     * @return the stageId
     */
    public Long getStageId() {
        return stageId;
    }

    /**
     * @param stageId the stageId to set
     */
    public void setStageId(Long stageId) {
        this.stageId = stageId;
    }

    /**
     * @return the stageName
     */
    public String getStageName() {
        return stageName;
    }

    /**
     * @param stageName the stageName to set
     */
    public void setStageName(String stageName) {
        this.stageName = stageName;
    }

    @Override
    public String toString() {
        return "CourseDo [courseId=" + courseId + ", courseName=" + courseName + ", versionId=" + versionId + ", versionName=" + versionName + ", stageId=" + stageId + ", stageName=" + stageName + "]";
    }

}
